require "test_helper"

class CatalogStackCheckerTest < ActiveSupport::TestCase
  setup do
    Catalog::Importer.import!
  end

  test "BPC-157 and TB-500 include the stored pair note" do
    compounds = Compound.where(slug: %w[bpc-157 tb-500]).to_a
    result = Catalog::StackChecker.new(compounds).result

    refute result.too_few
    note = result.pair_notes.find { |item| item.other_id == "tb-500" }
    assert note, "expected a pair note for tb-500"
    assert_match(/catalog convention/i, note.note)
    refute note.source_on_file
    refute_respond_to result, :safe
  end

  test "two compounds of the same class emit class overlap" do
    compounds = Compound.where(slug: %w[bpc-157 tb-500]).to_a
    result = Catalog::StackChecker.new(compounds).result

    assert_includes result.class_overlap, "healing"
  end

  test "any prohibited WADA member sets rollup prohibited" do
    compounds = Compound.where(slug: %w[bpc-157 tb-500]).to_a
    result = Catalog::StackChecker.new(compounds).result

    assert_equal "prohibited", result.wada.status
  end

  test "one compound only is too few" do
    result = Catalog::StackChecker.new(Compound.where(slug: "bpc-157")).result

    assert result.too_few
  end

  test "null WADA on one member is unknown when none are prohibited" do
    oral = build_compound("stack-oral", classification: "other", routes: [ "oral" ], wada: { "prohibited" => false })
    unknown = build_compound("stack-unknown", classification: "nootropic", routes: [ "oral" ], wada: nil)

    result = Catalog::StackChecker.new([ oral, unknown ]).result
    assert_equal "unknown", result.wada.status
  end

  test "injectable and non-injectable studied routes emit a route note" do
    injectable = build_compound(
      "stack-inj",
      classification: "other",
      routes: [ "injectable_subq" ],
      wada: { "prohibited" => false }
    )
    oral = build_compound(
      "stack-oral-b",
      classification: "nootropic",
      routes: [ "oral" ],
      wada: { "prohibited" => false }
    )

    result = Catalog::StackChecker.new([ injectable, oral ]).result
    assert result.route_clash
  end

  private
    def build_compound(slug, classification:, routes:, wada:)
      Compound.create!(
        slug: slug,
        name: slug,
        classification: classification,
        evidence_grade: "anecdotal",
        summary: "Test",
        last_reviewed_at: Date.current,
        confidence: "partial",
        payload: {
          "routes_studied" => routes,
          "wada" => wada,
          "stack_pair_notes" => []
        }
      )
    end
end
