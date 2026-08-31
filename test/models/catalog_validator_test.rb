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

  test "rejects a compound whose summary sources are only vendor" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      write_compound(root, sources: [ vendor_source ])

      result = Catalog::Validator.check(root: root)
      refute result.ok
      assert_includes result.errors.join, "summary sources"
    end
  end

  test "rejects a compound whose summary sources are only encyclopedia" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      write_compound(root, sources: [ encyclopedia_source ])

      result = Catalog::Validator.check(root: root)
      refute result.ok
      assert_includes result.errors.join, "summary sources"
    end
  end

  test "rejects a compound whose summary sources are only review" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      write_compound(root, sources: [ review_source ])

      result = Catalog::Validator.check(root: root)
      refute result.ok
      assert_includes result.errors.join, "summary sources"
    end
  end

  test "accepts a compound with primary_literature plus vendor sources" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      write_compound(root, sources: [ literature_source, vendor_source ])

      result = Catalog::Validator.check(root: root)
      assert result.ok, result.errors.join("\n")
    end
  end

  test "rejects a research use whose sources are only vendor" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      write_compound(
        root,
        sources: [ literature_source ],
        research_uses: [ { use: "claimed", evidence_grade: "anecdotal", sources: [ vendor_source ] } ]
      )

      result = Catalog::Validator.check(root: root)
      refute result.ok
      assert_includes result.errors.join, "research_uses[0]"
    end
  end

  test "accepts a research use with a review source" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      write_compound(
        root,
        sources: [ literature_source ],
        research_uses: [ { use: "reviewed use", evidence_grade: "preclinical", sources: [ review_source ] } ]
      )

      result = Catalog::Validator.check(root: root)
      assert result.ok, result.errors.join("\n")
    end
  end

  test "rejects a research use with missing sources" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      write_compound(
        root,
        sources: [ literature_source ],
        research_uses: [ { use: "claimed", evidence_grade: "anecdotal" } ]
      )

      result = Catalog::Validator.check(root: root)
      refute result.ok
      assert_includes result.errors.join, "research_uses[0] sources"
    end
  end

  test "product records may cite vendor sources only" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      write_compound(root, sources: [ literature_source ])
      write_minimal_provider(root)
      root.join("products").mkpath
      root.join("products/reschem-bad-capsule-10mg.json").write({
        id: "reschem-bad-capsule-10mg",
        schema_version: "1.0.0",
        compound_id: "ok-compound",
        provider_id: "reschem",
        product_url: "https://example.co.za/p",
        title_on_page: "Listed",
        form: "capsule",
        route: "oral",
        strength: "10 mg",
        price_zar: nil,
        price_visible_without_login: true,
        coa_stated: false,
        last_reviewed_at: "2026-08-26",
        reviewer: "test",
        sources: [ vendor_source ],
        confidence: "unverified"
      }.to_json)

      result = Catalog::Validator.check(root: root)
      assert result.ok, result.errors.join("\n")
    end
  end

  test "rejects a stack whose compound is missing" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      write_compound(root, sources: [ literature_source ])
      write_stack(root, compound_ids: [ "ok-compound", "missing-compound" ])

      result = Catalog::Validator.check(root: root)
      refute result.ok
      assert_includes result.errors.join, "missing-compound"
    end
  end

  test "rejects a stack with one member" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      write_compound(root, sources: [ literature_source ])
      write_stack(root, compound_ids: [ "ok-compound" ])

      result = Catalog::Validator.check(root: root)
      refute result.ok
      assert_includes result.errors.join, "at least two members"
    end
  end

  test "accepts a valid stack even when WADA would prohibit the pair" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      write_compound(root, sources: [ literature_source ])
      write_second_compound(root)
      write_stack(root, compound_ids: [ "ok-compound", "other-compound" ])

      result = Catalog::Validator.check(root: root)
      assert result.ok, result.errors.join("\n")
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
    def literature_source
      { url: "https://pubmed.ncbi.nlm.nih.gov/1/", title: "Paper", accessed_at: "2026-08-26", kind: "primary_literature", pmid: "1" }
    end

    def vendor_source
      { url: "https://example.co.za/p", title: "Shop", accessed_at: "2026-08-26", kind: "vendor" }
    end

    def encyclopedia_source
      { url: "https://en.wikipedia.org/wiki/Example", title: "Wiki", accessed_at: "2026-08-26", kind: "encyclopedia" }
    end

    def review_source
      { url: "https://pubmed.ncbi.nlm.nih.gov/2/", title: "Review", accessed_at: "2026-08-26", kind: "review" }
    end

    def write_compound(root, sources:, research_uses: [])
      compounds = root.join("compounds")
      compounds.mkpath
      compounds.join("ok-compound.json").write({
        id: "ok-compound",
        schema_version: "1.0.0",
        name: "Ok",
        aliases: [],
        class: "other",
        categories: [ "other" ],
        summary: "x",
        research_uses: research_uses,
        reported_protocols: [],
        routes_studied: [],
        forms: [],
        evidence_grade: "anecdotal",
        sahpra: {},
        wada: nil,
        stack_pair_notes: [],
        last_reviewed_at: "2026-08-26",
        reviewer: "test",
        sources: sources,
        confidence: "unverified"
      }.to_json)
    end

    def write_second_compound(root)
      compounds = root.join("compounds")
      compounds.mkpath
      compounds.join("other-compound.json").write({
        id: "other-compound",
        schema_version: "1.0.0",
        name: "Other",
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
        wada: { "prohibited" => true },
        stack_pair_notes: [],
        last_reviewed_at: "2026-08-26",
        reviewer: "test",
        sources: [ literature_source ],
        confidence: "unverified"
      }.to_json)
    end

    def write_stack(root, compound_ids:)
      stacks = root.join("stacks")
      stacks.mkpath
      stacks.join("example-stack.json").write({
        id: "example-stack",
        schema_version: "1.0.0",
        name: "Example pair",
        compound_ids: compound_ids,
        origin: "commonly_reported",
        last_reviewed_at: "2026-08-26",
        reviewer: "test",
        sources: [ vendor_source ],
        confidence: "unverified"
      }.to_json)
    end

    def write_minimal_provider(root)
      root.join("providers").mkpath
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
