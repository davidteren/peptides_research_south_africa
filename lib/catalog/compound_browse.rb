module Catalog
  class CompoundBrowse
    INJECTABLE_ROUTES = %w[injectable_subq injectable_im].freeze

    def initialize(params)
      @params = params.to_h.stringify_keys.slice("q", "route", "form", "classification", "provider_kind")
    end

    def records
      Compound.public_index.where(id: matching_ids).order(:name)
    end

    def self.compact_key(value)
      value.to_s.downcase.gsub(/[-_\s]/, "")
    end

    private
      def matching_ids
        scope = Compound.public_index
        scope = scope.where(classification: classification) if classification.present?
        if form.present? || provider_kind.present?
          scope = scope.joins(products: :provider)
          scope = scope.where(products: { form: form }) if form.present?
          scope = scope.where(providers: { kind: provider_kind }) if provider_kind.present?
        end
        scope.includes(:products).to_a.uniq(&:id).filter_map { |compound| compound.id if matches?(compound) }
      end

      def matches?(compound)
        matches_query?(compound) && matches_route?(compound)
      end

      def matches_query?(compound)
        return true if q.blank?

        key = self.class.compact_key(q)
        return false if key.empty?

        candidates = [ compound.name, compound.slug, compound.payload&.dig("inn") ]
        candidates.concat(Array(compound.payload&.dig("aliases")))
        candidates.any? { |value| self.class.compact_key(value) == key }
      end

      def matches_route?(compound)
        return true if route.blank?

        wanted = route == "injectable" ? INJECTABLE_ROUTES : [ route ]
        studied = Array(compound.payload&.dig("routes_studied"))
        product_routes = compound.products.map(&:route)
        studied.union(product_routes).intersect?(wanted)
      end

      def q
        @params["q"].to_s.strip
      end

      def route
        @params["route"].to_s.strip.presence
      end

      def form
        @params["form"].to_s.strip.presence
      end

      def classification
        @params["classification"].to_s.strip.presence
      end

      def provider_kind
        @params["provider_kind"].to_s.strip.presence
      end
  end
end
