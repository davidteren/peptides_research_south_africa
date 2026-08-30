require "test_helper"

class CatalogListingOrderTest < ActiveSupport::TestCase
  setup do
    @compound = Compound.create!(
      slug: "order-compound",
      name: "Order Compound",
      classification: "other",
      evidence_grade: "anecdotal",
      summary: "Test",
      last_reviewed_at: Date.current,
      confidence: "partial",
      payload: {}
    )
  end

  test "cheaper research storefront does not sort above a compounding pharmacy" do
    pharmacy = create_provider("order-pharm", "Alpha Pharmacy", "compounding_pharmacy")
    shop = create_provider("order-shop", "Zeta Shop", "research_storefront")
    dear = create_product("order-dear", pharmacy, 9999, "Dear vial")
    cheap = create_product("order-cheap", shop, 1, "Cheap vial")

    ordered = Catalog::ListingOrder.new(Product.where(id: [ dear.id, cheap.id ]).includes(:provider)).records
    assert_equal [ dear, cheap ], ordered
  end

  test "equal kinds fall back to provider name then title" do
    first = create_provider("order-a", "Alpha Labs", "research_storefront")
    second = create_provider("order-b", "Beta Labs", "research_storefront")
    later = create_product("order-later", first, 10, "Z title")
    earlier = create_product("order-earlier", first, 50, "A title")
    other = create_product("order-other", second, 5, "Mid title")

    ordered = Catalog::ListingOrder.new(
      Product.where(id: [ later.id, earlier.id, other.id ]).includes(:provider)
    ).records
    assert_equal [ earlier, later, other ], ordered
  end

  test "marketplace and unknown share the last bucket" do
    market = create_provider("order-market", "AAA Market", "marketplace")
    unknown = create_provider("order-unknown", "ZZZ Unknown", "unknown")
    clinic = create_provider("order-clinic", "Mid Clinic", "clinic")
    market_row = create_product("order-market-row", market, 1, "Market")
    unknown_row = create_product("order-unknown-row", unknown, 2, "Unknown")
    clinic_row = create_product("order-clinic-row", clinic, 999, "Clinic")

    ordered = Catalog::ListingOrder.new(
      Product.where(id: [ market_row.id, unknown_row.id, clinic_row.id ]).includes(:provider)
    ).records
    assert_equal [ clinic_row, market_row, unknown_row ], ordered
  end

  test "null prices do not error" do
    provider = create_provider("order-null", "Null Shop", "research_storefront")
    row = create_product("order-null-row", provider, nil, "No price")

    ordered = Catalog::ListingOrder.new(Product.where(id: row.id).includes(:provider)).records
    assert_equal [ row ], ordered
  end

  private
    def create_provider(slug, name, kind)
      Provider.create!(
        slug: slug,
        name: name,
        kind: kind,
        status: "active",
        website: "https://example.test",
        last_reviewed_at: Date.current,
        confidence: "partial",
        payload: { "country" => "ZA" }
      )
    end

    def create_product(slug, provider, price, title)
      Product.create!(
        slug: slug,
        compound: @compound,
        provider: provider,
        form: "capsule",
        route: "oral",
        strength: "10 mg",
        price_zar: price,
        title_on_page: title,
        product_url: "https://example.test/#{slug}",
        price_visible_without_login: true,
        last_reviewed_at: Date.current,
        confidence: "partial",
        payload: {}
      )
    end
end
