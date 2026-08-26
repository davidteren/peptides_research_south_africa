require "test_helper"

class CatalogValidatorTest < ActiveSupport::TestCase
  test "live catalog JSON is valid" do
    result = Catalog::Validator.check
    assert result.ok, result.errors.join("\n")
  end

  test "rejects a compound with empty sources" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      compounds = root.join("compounds")
      compounds.mkpath
      compounds.join("bad.json").write({
        id: "bad-compound",
        schema_version: "1.0.0",
        name: "Bad",
        aliases: [],
        class: "other",
        categories: [ "other" ],
        summary: "x",
        research_uses: [],
        reported_protocols: [],
        routes_studied: [],
        forms: [],
        evidence_grade: "anecdotal",
        sahpra: {},
        wada: nil,
        stack_pair_notes: [],
        last_reviewed_at: "2026-08-26",
        reviewer: "test",
        sources: [],
        confidence: "unverified"
      }.to_json)

      result = Catalog::Validator.check(root: root)
      refute result.ok
      assert_includes result.errors.join, "sources must have at least one entry"
    end
  end

  test "rejects a product whose compound is missing" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      %w[compounds providers products].each { |name| root.join(name).mkpath }

      write_minimal_provider(root)
      root.join("products/orphan.json").write({
        id: "reschem-missing-capsule-10mg",
        schema_version: "1.0.0",
        compound_id: "missing-compound",
        provider_id: "reschem",
        product_url: "https://example.co.za/p",
        title_on_page: "Missing",
        form: "capsule",
        route: "oral",
        strength: "10 mg",
        price_zar: nil,
        price_visible_without_login: true,
        coa_stated: false,
        last_reviewed_at: "2026-08-26",
        reviewer: "test",
        sources: [ { url: "https://example.co.za/p", title: "x", accessed_at: "2026-08-26", kind: "vendor" } ],
        confidence: "unverified"
      }.to_json)

      result = Catalog::Validator.check(root: root)
      refute result.ok
      assert_includes result.errors.join, "compound_id"
    end
  end

  private
    def write_minimal_provider(root)
      root.join("providers/reschem.json").write({
        id: "reschem",
        schema_version: "1.0.0",
        name: "Reschem",
        kind: "research_storefront",
        website: "https://reschem.co.za",
        country: "ZA",
        currency: "ZAR",
        prescription_required: "no",
        listing_posture: "research_use_only",
        status: "active",
        last_reviewed_at: "2026-08-26",
        reviewer: "test",
        sources: [ { url: "https://reschem.co.za", title: "home", accessed_at: "2026-08-26", kind: "vendor" } ],
        confidence: "seen_live"
      }.to_json)
    end
end
