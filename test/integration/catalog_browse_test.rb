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

  test "bpc-157 shows WADA S0 SAHPRA warning and legal disclaimer" do
    get compound_path("bpc-157")
    assert_response :success
    assert_select "#compound-wada"
    assert_select "#compound-wada-prohibited", text: I18n.t("compounds.wada_prohibited")
    assert_select "#compound-wada-class", text: /S0/
    assert_select "#compound-wada-year", text: /2026/
    assert_select "#compound-wada-link"
    assert_select "#compound-saids"
    assert_select "#compound-sahpra-warning"
    assert_select "#compound-sahpra-notes"
    assert_select "#compound-sahpra-link"
    assert_select "#compound-legal-disclaimer"
    assert_select "#catalog-disclaimer"
  end

  test "tb-500 shows WADA S2.3" do
    get compound_path("tb-500")
    assert_response :success
    assert_select "#compound-wada-class", text: /S2\.3/
  end

  test "ghk-cu is not on the peptide warning and is not WADA prohibited" do
    get compound_path("ghk-cu")
    assert_response :success
    assert_select "#compound-sahpra-warning", count: 0
    assert_select "#compound-wada-prohibited", text: I18n.t("compounds.wada_not_prohibited")
  end

  test "null WADA payload shows empty status without crashing" do
    compound = Compound.find_by!(slug: "noopept")
    payload = compound.payload.deep_dup
    payload["wada"] = nil
    compound.update!(payload: payload)

    get compound_path("noopept")
    assert_response :success
    assert_select "#compound-wada-empty"
    assert_select "#compound-wada-link"
    assert_select "#compound-wada-prohibited", count: 0
  end

  test "registration numbers and schedule render when present" do
    compound = Compound.find_by!(slug: "ghk-cu")
    payload = compound.payload.deep_dup
    payload["sahpra"]["registration_numbers"] = [ "TEST-1" ]
    payload["sahpra"]["schedule"] = "S4"
    compound.update!(payload: payload)

    get compound_path("ghk-cu")
    assert_response :success
    assert_select "#compound-sahpra-registration-numbers", text: /TEST-1/
    assert_select "#compound-sahpra-schedule", text: /S4/
  end

  test "non-SA listing shows the import rule and ZA listing does not" do
    provider = Provider.find_by!(slug: "reschem")
    payload = provider.payload.deep_dup
    payload["country"] = "US"
    provider.update!(payload: payload)
    product = Product.find_by!(slug: "reschem-bpc-157-blend-nasal-10mg")

    get compound_path("bpc-157")
    assert_response :success
    assert_select "#listing-import-note-#{product.slug}"
    assert_select "#listing-import-note-#{product.slug}", text: /stated rule/
    assert_no_match(/permits import/i, response.body)
  end

  test "ZA listing does not show the import rule" do
    product = Product.find_by!(slug: "reschem-bpc-157-blend-nasal-10mg")

    get compound_path("bpc-157")
    assert_response :success
    assert_select "#listing-import-note-#{product.slug}", count: 0
  end

  test "missing provider country does not show the import rule" do
    provider = Provider.find_by!(slug: "reschem")
    payload = provider.payload.deep_dup
    payload.delete("country")
    provider.update!(payload: payload)
    product = Product.find_by!(slug: "reschem-bpc-157-blend-nasal-10mg")

    get compound_path("bpc-157")
    assert_response :success
    assert_select "#listing-import-note-#{product.slug}", count: 0
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
