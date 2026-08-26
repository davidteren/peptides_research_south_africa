require "test_helper"

class CatalogBrowseTest < ActionDispatch::IntegrationTest
  setup do
    Catalog::Importer.import!
  end

  test "home shows the disclaimer and catalog links" do
    get root_path
    assert_response :success
    assert_select "#catalog-disclaimer"
    assert_select "#catalog-disclaimer-sahpra-link"
    assert_select "#site-nav-compounds"
    assert_select "#site-nav-providers"
  end

  test "compound index lists name class routes and evidence grade" do
    get compounds_path
    assert_response :success
    assert_select "#compound-index"
    assert_select "#compound-card-bpc-157"
    assert_select "#compound-link-bpc-157", text: "BPC-157"
    assert_match "Preclinical", response.body
  end

  test "compound detail shows summary and disclaimer above the fold" do
    get compound_path("bpc-157")
    assert_response :success
    assert_select "#catalog-disclaimer"
    assert_select "#compound-summary"
    assert_select "#compound-protocols, #compound-protocols-empty"
  end

  test "provider index hides nothing from the active first drop" do
    get providers_path
    assert_response :success
    assert_select "#provider-card-reschem"
    assert_select "#provider-link-reschem"
  end

  test "research storefront detail carries the unregistered-supply notice" do
    get provider_path("reschem")
    assert_response :success
    assert_select "#provider-research-notice"
    assert_select "#catalog-disclaimer"
  end

  test "clinic prices stay off the page when login gated" do
    get provider_path("the-clinic")
    assert_response :success
    assert_no_match(/R[0-9]/, response.body)
  end
end
