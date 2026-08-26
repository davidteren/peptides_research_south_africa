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
end
