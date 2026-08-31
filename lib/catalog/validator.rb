require "json"

module Catalog
  class Validator
    SHARED_KEYS = %w[id schema_version last_reviewed_at reviewer sources confidence].freeze
    TYPE_KEYS = {
      "compound" => %w[name aliases class categories summary research_uses reported_protocols routes_studied forms evidence_grade sahpra wada stack_pair_notes],
      "provider" => %w[name kind website country currency prescription_required listing_posture status],
      "product" => %w[compound_id provider_id product_url title_on_page form route strength price_zar price_visible_without_login coa_stated],
      "stack" => %w[name compound_ids origin]
    }.freeze
    DATE = /\A\d{4}-\d{2}-\d{2}\z/
    KEBAB = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/
    SCHEMA_VERSION = "1.0.0"
    SUMMARY_SOURCE_KINDS = %w[regulator primary_literature].freeze
    RESEARCH_USE_SOURCE_KINDS = %w[regulator primary_literature review].freeze

    Result = Struct.new(:ok, :errors, keyword_init: true)

    def self.check(root: Catalog::DATA_ROOT)
      new(root).check
    end

    def initialize(root)
      @root = Pathname(root)
    end

    def check
      errors = []
      ids = TYPE_KEYS.keys.index_with { [] }

      TYPE_KEYS.each_key do |type|
        dir = @root.join(Catalog::RECORD_DIRS[type])
        next unless dir.directory?

        dir.glob("*.json").sort.each do |path|
          errors.concat(check_file(type, path, ids))
        end
      end

      errors.concat(check_product_refs(ids))
      errors.concat(check_stack_members(ids))
      Result.new(ok: errors.empty?, errors: errors)
    end

    private

    def check_file(type, path, ids)
      relative = path.relative_path_from(@root).to_s
      data = JSON.parse(path.read)
      errors = []

      unless data.is_a?(Hash)
        return [ "#{relative}: must be a JSON object" ]
      end

      (SHARED_KEYS + TYPE_KEYS[type]).each do |key|
        errors << "#{relative}: missing #{key}" unless data.key?(key)
      end

      id = data["id"]
      if id.is_a?(String) && id.match?(KEBAB)
        ids[type] << id
      else
        errors << "#{relative}: id must be a kebab-case slug"
      end

      errors << "#{relative}: schema_version must be #{SCHEMA_VERSION}" unless data["schema_version"] == SCHEMA_VERSION
      errors << "#{relative}: last_reviewed_at must be YYYY-MM-DD" unless data["last_reviewed_at"].to_s.match?(DATE)
      errors << "#{relative}: reviewer must be present" if data["reviewer"].to_s.strip.empty?

      sources = data["sources"]
      if !sources.is_a?(Array) || sources.empty?
        errors << "#{relative}: sources must have at least one entry"
      else
        sources.each_with_index do |source, i|
          next unless source.is_a?(Hash)
          errors << "#{relative}: sources[#{i}] missing url" if source["url"].to_s.strip.empty?
          errors << "#{relative}: sources[#{i}] accessed_at must be YYYY-MM-DD" unless source["accessed_at"].to_s.match?(DATE)
        end
      end

      if type == "product" && !data["price_zar"].nil? && data["price_checked_on"].to_s !~ DATE
        errors << "#{relative}: non-null price_zar needs price_checked_on"
      end

      errors.concat(check_compound_citations(relative, data)) if type == "compound"

      errors
    rescue JSON::ParserError => e
      [ "#{relative}: invalid JSON (#{e.message})" ]
    end

    def check_compound_citations(relative, data)
      errors = []
      kinds = source_kinds(data["sources"])
      unless kinds.intersect?(SUMMARY_SOURCE_KINDS)
        errors << "#{relative}: summary sources need regulator or primary_literature"
      end

      Array(data["research_uses"]).each_with_index do |use, i|
        next unless use.is_a?(Hash)

        sources = use["sources"]
        if !sources.is_a?(Array) || sources.empty?
          errors << "#{relative}: research_uses[#{i}] sources must have at least one entry"
          next
        end

        unless source_kinds(sources).intersect?(RESEARCH_USE_SOURCE_KINDS)
          errors << "#{relative}: research_uses[#{i}] sources need regulator, primary_literature, or review"
        end
      end

      errors
    end

    def source_kinds(sources)
      Array(sources).filter_map { |source| source["kind"] if source.is_a?(Hash) }
    end

    def check_product_refs(ids)
      errors = []
      dir = @root.join("products")
      return errors unless dir.directory?

      dir.glob("*.json").sort.each do |path|
        relative = path.relative_path_from(@root).to_s
        data = JSON.parse(path.read)
        unless ids["compound"].include?(data["compound_id"])
          errors << "#{relative}: compound_id #{data["compound_id"].inspect} has no compound file"
        end
        unless ids["provider"].include?(data["provider_id"])
          errors << "#{relative}: provider_id #{data["provider_id"].inspect} has no provider file"
        end
      end
      errors
    end

    def check_stack_members(ids)
      errors = []
      dir = @root.join("stacks")
      return errors unless dir.directory?

      dir.glob("*.json").sort.each do |path|
        relative = path.relative_path_from(@root).to_s
        data = JSON.parse(path.read)
        members = Array(data["compound_ids"])
        if members.size < 2
          errors << "#{relative}: compound_ids needs at least two members"
        end
        members.each do |compound_id|
          next if ids["compound"].include?(compound_id)

          errors << "#{relative}: compound_id #{compound_id.inspect} has no compound file"
        end
      end
      errors
    end
  end
end
