require "test_helper"

class CatalogImporterTest < ActiveSupport::TestCase
  test "imports live catalog compounds and providers" do
    Catalog::Importer.import!

    assert Compound.exists?(slug: "bpc-157")
    assert Provider.exists?(slug: "reschem")
    refute Compound.exists?(confidence: "rumour")
    refute Provider.where(status: %w[down excluded]).exists?
  end

  test "skips rumour compounds" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      %w[compounds providers products].each { |name| root.join(name).mkpath }
      root.join("compounds/shown.json").write(compound_json("shown", "partial"))
      root.join("compounds/hidden.json").write(compound_json("hidden", "rumour"))

      Catalog::Importer.import!(root: root)

      assert Compound.exists?(slug: "shown")
      refute Compound.exists?(slug: "hidden")
    end
  end

  test "skips user_saved stacks on the public index" do
    Dir.mktmpdir do |dir|
      root = Pathname(dir)
      %w[compounds providers products stacks].each { |name| root.join(name).mkpath }
      root.join("compounds/shown.json").write(compound_json("shown", "partial"))
      root.join("compounds/other.json").write(compound_json("other", "partial"))
      root.join("stacks/kept.json").write(stack_json("kept", "commonly_reported", %w[shown other]))
      root.join("stacks/hidden.json").write(stack_json("hidden", "user_saved", %w[shown other]))

      Catalog::Importer.import!(root: root)

      assert Stack.exists?(slug: "kept")
      refute Stack.exists?(slug: "hidden")
    end
  end

  private
    def compound_json(id, confidence)
      {
        id: id,
        schema_version: "1.0.0",
        name: id.titleize,
        aliases: [],
        class: "other",
        categories: [ "other" ],
        summary: "Cited summary.",
        research_uses: [],
        reported_protocols: [],
        routes_studied: [],
        forms: [],
        evidence_grade: "anecdotal",
        sahpra: { registered_medicine: false, on_unregistered_warning_list: false },
        wada: { prohibited: false },
        stack_pair_notes: [],
        last_reviewed_at: "2026-08-26",
        reviewer: "test",
        sources: [ { url: "https://www.sahpra.org.za/peptide-products-public-information/", title: "SAHPRA", accessed_at: "2026-08-26", kind: "regulator" } ],
        confidence: confidence
      }.to_json
    end

    def stack_json(id, origin, compound_ids)
      {
        id: id,
        schema_version: "1.0.0",
        name: id.titleize,
        compound_ids: compound_ids,
        origin: origin,
        last_reviewed_at: "2026-08-26",
        reviewer: "test",
        sources: [ { url: "https://example.co.za/p", title: "Pair", accessed_at: "2026-08-26", kind: "vendor" } ],
        confidence: "unverified"
      }.to_json
    end
end
