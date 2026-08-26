require "json"

module Catalog
  class Validator
    SHARED_KEYS = %w[id schema_version last_reviewed_at reviewer sources confidence].freeze
    TYPE_KEYS = {
      "compound" => %w[name aliases class categories summary research_uses reported_protocols routes_studied forms evidence_grade sahpra wada stack_pair_notes],
      "provider" => %w[name kind website country currency prescription_required listing_posture status],
      "product" => %w[compound_id provider_id product_url title_on_page form route strength price_zar price_visible_without_login coa_stated]
    }.freeze
    DATE = /\A\d{4}-\d{2}-\d{2}\z/
    KEBAB = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/
    SCHEMA_VERSION = "1.0.0"

    Result = Struct.new(:ok, :errors, keyword_init: true)

    def self.check(root: Catalog::DATA_ROOT)
      new(root).check
    end

    def initialize(root)
      @root = Pathname(root)
    end

    def check
      errors = []
      ids = { "compound" => [], "provider" => [], "product" => [] }

      TYPE_KEYS.each_key do |type|
        dir = @root.join(Catalog::RECORD_DIRS[type])
        next unless dir.directory?

        dir.glob("*.json").sort.each do |path|
          errors.concat(check_file(type, path, ids))
        end
      end

      errors.concat(check_product_refs(ids))
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

      errors
    rescue JSON::ParserError => e
      [ "#{relative}: invalid JSON (#{e.message})" ]
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
  end
end
