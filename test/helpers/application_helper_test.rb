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
end
