require "test_helper"

class CatalogCompoundBrowseTest < ActiveSupport::TestCase
  setup do
    Catalog::Importer.import!
  end

  test "BPC157 and bpc 157 both return BPC-157" do
    [ "BPC157", "bpc 157" ].each do |query|
      slugs = Catalog::CompoundBrowse.new(q: query).records.map(&:slug)
      assert_equal [ "bpc-157" ], slugs, "expected #{query} to match BPC-157"
    end
  end

  test "bepecin alias returns BPC-157" do
    slugs = Catalog::CompoundBrowse.new(q: "bepecin").records.map(&:slug)
    assert_equal [ "bpc-157" ], slugs
  end

  test "compact-key substring that is not an alias returns none" do
    assert_empty Catalog::CompoundBrowse.new(q: "bpc").records
  end

  test "unknown query returns none" do
    assert_empty Catalog::CompoundBrowse.new(q: "xyzzy-not-a-peptide").records
  end

  test "injectable route includes a compound whose only studied route is injectable_subq" do
    Compound.create!(
      slug: "inject-only",
      name: "Inject Only",
      classification: "other",
      evidence_grade: "anecdotal",
      summary: "Test compound",
      last_reviewed_at: Date.current,
      confidence: "partial",
      payload: { "routes_studied" => [ "injectable_subq" ], "aliases" => [], "inn" => nil }
    )

    slugs = Catalog::CompoundBrowse.new(route: "injectable").records.map(&:slug)
    assert_includes slugs, "inject-only"
  end

  test "injectable route includes BPC-157 through listing routes" do
    slugs = Catalog::CompoundBrowse.new(route: "injectable").records.map(&:slug)
    assert_includes slugs, "bpc-157"
  end

  test "results are ordered by name not price" do
    names = Catalog::CompoundBrowse.new({}).records.map(&:name)
    assert_equal names.sort, names
  end

  test "rumour compounds stay out" do
    Compound.create!(
      slug: "rumour-peptide",
      name: "Rumour Peptide",
      classification: "other",
      evidence_grade: "anecdotal",
      summary: "Hidden",
      last_reviewed_at: Date.current,
      confidence: "rumour",
      payload: { "routes_studied" => [], "aliases" => [ "Rumour Peptide" ], "inn" => nil }
    )

    slugs = Catalog::CompoundBrowse.new(q: "Rumour Peptide").records.map(&:slug)
    refute_includes slugs, "rumour-peptide"
  end

  test "classification filter matches the stored class" do
    slugs = Catalog::CompoundBrowse.new(classification: "nootropic").records.map(&:slug)
    assert_includes slugs, "noopept"
    refute_includes slugs, "bpc-157"
  end
end
