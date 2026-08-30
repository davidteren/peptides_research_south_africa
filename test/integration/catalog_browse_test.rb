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
    assert_select "#compound-search"
    assert_select "#compound-search-q"
    assert_select "#compound-search-submit"
    assert_select "#filter-route-injectable"
    assert_match "Preclinical", response.body
    assert_select "#compound-stamp-bpc-157", text: /Preclinical/
    assert_select "#compound-stamp-citation-bpc-157"
    assert_select "[data-testid=efficacy-stars]", count: 0
    assert_no_match(/cheapest/i, response.body)
  end

  test "alias search keeps BPC-157 on the index" do
    get compounds_path, params: { q: "bpc 157" }
    assert_response :success
    assert_select "#compound-card-bpc-157"
    assert_select "#search-no-match", count: 0
  end

  test "unknown search shows no match and a report link" do
    get compounds_path, params: { q: "xyzzy-not-a-peptide" }
    assert_response :success
    assert_select "#search-no-match"
    assert_select "#search-report-alias"
    assert_select "[data-testid=compound-card]", count: 0
  end

  test "injectable filter does not 500" do
    get compounds_path, params: { route: "injectable" }
    assert_response :success
    assert_select "#filter-route-injectable[aria-current=true]"
  end

  test "filter with no rows says the filters matched nothing" do
    get compounds_path, params: { classification: "ghrh" }
    assert_response :success
    assert_select "#filter-no-match"
    assert_select "#compound-index-empty", count: 0
  end

  test "compound detail shows summary and disclaimer above the fold" do
    get compound_path("bpc-157")
    assert_response :success
    assert_select "#catalog-disclaimer"
    assert_select "#compound-summary"
    assert_select "#compound-checked"
    assert_select "#compound-inn", count: 0
    assert_select "#compound-protocols, #compound-protocols-empty"
  end

  test "noopept shows the INN label" do
    get compound_path("noopept")
    assert_response :success
    assert_select "#compound-inn", text: /omberacetam/
  end

  test "stale review date shows needs review" do
    compound = Compound.find_by!(slug: "bpc-157")
    compound.update!(last_reviewed_at: Date.current - 91)

    get compound_path("bpc-157")
    assert_response :success
    assert_select "#compound-needs-review"
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
    assert_select "#provider-checked"
    assert_select "#catalog-disclaimer"
  end

  test "clinic prices stay off the page when login gated" do
    get provider_path("the-clinic")
    assert_response :success
    assert_no_match(/R[0-9]/, response.body)
  end

  test "compound comparison table lists form origin price and has no buy control" do
    product = Product.find_by!(slug: "reschem-bpc-157-blend-nasal-10mg")

    get compound_path("bpc-157")
    assert_response :success
    assert_select "#compound-comparison"
    assert_select "#comparison-col-form"
    assert_select "#comparison-col-route"
    assert_select "#comparison-col-price"
    assert_select "#comparison-col-ships-from"
    assert_select "#comparison-col-cold-chain"
    assert_select "#compound-listing-#{product.slug}"
    assert_select "#listing-form-#{product.slug}"
    assert_select "#listing-route-#{product.slug}"
    assert_select "#listing-price-#{product.slug}", text: /R999 as of 2026-08-26/
    assert_select "#listing-ships-from-#{product.slug}", text: /South Africa/
    assert_select "#listing-cold-chain-#{product.slug}", text: I18n.t("products.cold_chain_unknown")
    assert_select "[id^=buy-]", count: 0
    assert_no_match(/tested safe/i, response.body)
    assert_no_match(/safe without cold-chain/i, response.body)
  end

  test "comparison table is not cheapest first" do
    get compound_path("bpc-157")
    assert_response :success
    first_row = css_select("[data-testid=product-row]").first
    assert first_row, "expected a comparison row"
    assert_match(/compound-listing-biopeptics-bpc-157-lyophilized-vial-10mg/, first_row["id"])
  end

  test "stated COA listing links off-site and unstated listing has no COA claim" do
    stated = Product.find_by!(slug: "reschem-bpc-157-blend-nasal-10mg")
    unstated = Product.find_by!(slug: "biopeptics-bpc-157-lyophilized-vial-10mg")

    get compound_path("bpc-157")
    assert_response :success
    assert_select "#listing-coa-#{stated.slug}", text: /Provider states a COA/
    assert_select "#listing-coa-link-#{stated.slug}[href^='https://cdn.shopify.com']"
    assert_select "#listing-coa-link-#{stated.slug}[rel='noopener noreferrer']"
    assert_select "#listing-coa-#{unstated.slug}", count: 0
    assert_no_match(/tested safe/i, response.body)
  end

  test "provider comparison table lists products without a buy control" do
    product = Product.find_by!(slug: "reschem-bpc-157-blend-nasal-10mg")

    get provider_path("reschem")
    assert_response :success
    assert_select "#provider-comparison"
    assert_select "#provider-listing-#{product.slug}"
    assert_select "#listing-form-#{product.slug}"
    assert_select "[id^=buy-]", count: 0
  end
end
