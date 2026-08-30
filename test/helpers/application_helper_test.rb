require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "registered medicine true is yes" do
    assert_equal I18n.t("compounds.sahpra_registered_yes"), registered_medicine_label(true)
  end

  test "registered medicine false is no" do
    assert_equal I18n.t("compounds.sahpra_registered_no"), registered_medicine_label(false)
  end

  test "registered medicine nil is unknown" do
    assert_equal I18n.t("compounds.sahpra_registered_unknown"), registered_medicine_label(nil)
  end

  test "non_sa_shipper is true for country US" do
    provider = Struct.new(:payload).new({ "country" => "US" })
    assert non_sa_shipper?(provider)
  end

  test "non_sa_shipper is false for country ZA" do
    provider = Struct.new(:payload).new({ "country" => "ZA" })
    refute non_sa_shipper?(provider)
  end

  test "non_sa_shipper is false when country is missing" do
    provider = Struct.new(:payload).new({})
    refute non_sa_shipper?(provider)
  end

  test "needs_review is true when the date is 91 days ago" do
    assert needs_review?(Date.current - 91)
  end

  test "needs_review is false for today" do
    refute needs_review?(Date.current)
  end

  test "needs_review is false when date is blank" do
    refute needs_review?(nil)
  end

  test "primary_citation prefers pmid from primary literature" do
    compound = Struct.new(:payload).new({
      "sources" => [
        { "kind" => "vendor", "title" => "Shop" },
        { "kind" => "primary_literature", "title" => "Paper", "pmid" => "14554208" }
      ]
    })
    assert_equal "14554208", primary_citation(compound)
  end

  test "ships_from_label for ZA includes city" do
    provider = Struct.new(:payload, :city).new({ "country" => "ZA" }, "Cape Town")
    assert_equal I18n.t("products.ships_from_za_city", city: "Cape Town"), ships_from_label(provider)
  end

  test "ships_from_label for ZA without city is South Africa" do
    provider = Struct.new(:payload, :city).new({ "country" => "ZA" }, nil)
    assert_equal I18n.t("products.ships_from_za"), ships_from_label(provider)
  end

  test "ships_from_label for a non-ZA country is abroad" do
    provider = Struct.new(:payload, :city).new({ "country" => "US" }, nil)
    assert_equal I18n.t("products.ships_from_abroad", region: "US"), ships_from_label(provider)
  end

  test "ships_from_label is unknown when country is missing" do
    provider = Struct.new(:payload, :city).new({}, nil)
    assert_equal I18n.t("products.ships_from_unknown"), ships_from_label(provider)
  end

  test "cold_chain_label is tri-state" do
    yes = Struct.new(:payload).new({ "cold_chain" => true })
    no = Struct.new(:payload).new({ "cold_chain" => false })
    unknown = Struct.new(:payload).new({ "cold_chain" => nil })
    assert_equal I18n.t("products.cold_chain_yes"), cold_chain_label(yes)
    assert_equal I18n.t("products.cold_chain_no"), cold_chain_label(no)
    assert_equal I18n.t("products.cold_chain_unknown"), cold_chain_label(unknown)
  end

  test "listing_price_label uses rand as of when visible" do
    product = Struct.new(:price_zar, :price_visible_without_login?, :payload).new(
      999, true, { "price_checked_on" => "2026-08-26" }
    )
    assert_equal I18n.t("products.price_as_of", amount: 999, date: "2026-08-26"), listing_price_label(product)
  end

  test "listing_price_label is unknown when login gated" do
    product = Struct.new(:price_zar, :price_visible_without_login?, :payload).new(
      999, false, { "price_checked_on" => "2026-08-26" }
    )
    assert_equal I18n.t("products.price_unknown"), listing_price_label(product)
  end

  test "listing_price_label is unknown when price is null" do
    product = Struct.new(:price_zar, :price_visible_without_login?, :payload).new(
      nil, true, {}
    )
    assert_equal I18n.t("products.price_unknown"), listing_price_label(product)
  end
end
