module Catalog
  class ListingOrder
    KIND_RANK = {
      "compounding_pharmacy" => 0,
      "clinic" => 1,
      "nootropic_retailer" => 2,
      "research_storefront" => 3,
      "international" => 4
    }.freeze
    FALLBACK_RANK = 5

    def initialize(products)
      @products = products
    end

    def records
      @products.sort_by { |product| rank_key(product) }
    end

    private
      def rank_key(product)
        provider = product.provider
        [
          KIND_RANK.fetch(provider.kind, FALLBACK_RANK),
          provider.name.to_s.downcase,
          product.title_on_page.to_s.downcase
        ]
      end
  end
end
