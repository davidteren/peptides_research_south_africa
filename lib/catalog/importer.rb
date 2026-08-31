require "json"

module Catalog
  class Importer
    def self.import!(root: Catalog::DATA_ROOT)
      new(root).import!
    end

    def initialize(root)
      @root = Pathname(root)
    end

    def import!
      result = Validator.check(root: @root)
      raise ArgumentError, result.errors.join("\n") unless result.ok

      import_compounds
      import_providers
      import_products
      import_stacks
    end

    private

    def import_compounds
      seen = []
      each_record("compounds") do |data|
        next if data["confidence"] == "rumour"

        seen << data["id"]
        record = Compound.find_or_initialize_by(slug: data["id"])
        record.assign_attributes(
          name: data["name"],
          classification: data["class"],
          evidence_grade: data["evidence_grade"],
          summary: data["summary"],
          last_reviewed_at: data["last_reviewed_at"],
          confidence: data["confidence"],
          payload: data
        )
        record.save!
      end
      Compound.where.not(slug: seen).find_each(&:destroy!)
    end

    def import_providers
      seen = []
      each_record("providers") do |data|
        next if %w[down excluded].include?(data["status"])

        seen << data["id"]
        record = Provider.find_or_initialize_by(slug: data["id"])
        record.assign_attributes(
          name: data["name"],
          kind: data["kind"],
          status: data["status"],
          website: data["website"],
          city: data["city"],
          prescription_required: data["prescription_required"],
          listing_posture: data["listing_posture"],
          last_reviewed_at: data["last_reviewed_at"],
          confidence: data["confidence"],
          payload: data
        )
        record.save!
      end
      Provider.where.not(slug: seen).find_each(&:destroy!)
    end

    def import_products
      seen = []
      each_record("products") do |data|
        compound = Compound.find_by(slug: data["compound_id"])
        provider = Provider.find_by(slug: data["provider_id"])
        next if compound.nil? || provider.nil?

        seen << data["id"]
        record = Product.find_or_initialize_by(slug: data["id"])
        record.assign_attributes(
          compound: compound,
          provider: provider,
          form: data["form"],
          route: data["route"],
          strength: data["strength"],
          price_zar: data["price_zar"],
          title_on_page: data["title_on_page"],
          product_url: data["product_url"],
          price_visible_without_login: data["price_visible_without_login"],
          last_reviewed_at: data["last_reviewed_at"],
          confidence: data["confidence"],
          payload: data
        )
        record.save!
      end
      Product.where.not(slug: seen).find_each(&:destroy!)
    end

    def import_stacks
      seen = []
      each_record("stacks") do |data|
        next if data["origin"] == "user_saved"

        seen << data["id"]
        record = Stack.find_or_initialize_by(slug: data["id"])
        record.assign_attributes(
          name: data["name"],
          origin: data["origin"],
          last_reviewed_at: data["last_reviewed_at"],
          confidence: data["confidence"],
          payload: data
        )
        record.save!
      end
      Stack.where.not(slug: seen).find_each(&:destroy!)
    end

    def each_record(dir)
      path = @root.join(dir)
      return unless path.directory?

      path.glob("*.json").sort.each do |file|
        yield JSON.parse(file.read)
      end
    end
  end
end
