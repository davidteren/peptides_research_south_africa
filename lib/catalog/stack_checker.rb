module Catalog
  class StackChecker
    INJECTABLE_ROUTES = %w[injectable_subq injectable_im].freeze

    Result = Struct.new(:too_few, :class_overlap, :route_clash, :pair_notes, :wada, keyword_init: true)
    PairNote = Struct.new(:from_id, :other_id, :kind, :note, :source_on_file, keyword_init: true)
    WadaRollup = Struct.new(:status, keyword_init: true)

    def initialize(compounds)
      @compounds = Array(compounds).compact
    end

    def result
      if @compounds.size < 2
        return Result.new(too_few: true, class_overlap: [], route_clash: false, pair_notes: [], wada: nil)
      end

      Result.new(
        too_few: false,
        class_overlap: class_overlap,
        route_clash: route_clash?,
        pair_notes: pair_notes,
        wada: wada_rollup
      )
    end

    private
      def slugs
        @compounds.map(&:slug)
      end

      def class_overlap
        grouped = @compounds.group_by(&:classification)
        grouped.filter_map { |classification, members| classification if classification.present? && members.size >= 2 }
      end

      def route_clash?
        injectable = @compounds.any? { |compound| injectable?(compound) }
        non_injectable = @compounds.any? { |compound| !injectable?(compound) }
        injectable && non_injectable
      end

      def injectable?(compound)
        Array(compound.payload&.dig("routes_studied")).intersect?(INJECTABLE_ROUTES)
      end

      def pair_notes
        notes = []
        members = slugs
        @compounds.each do |compound|
          Array(compound.payload&.dig("stack_pair_notes")).each do |note|
            next unless note.is_a?(Hash)
            other_id = note["other_id"].to_s
            next unless members.include?(other_id)

            notes << PairNote.new(
              from_id: compound.slug,
              other_id: other_id,
              kind: note["kind"],
              note: note["note"],
              source_on_file: Array(note["sources"]).any?
            )
          end
        end
        notes
      end

      def wada_rollup
        flags = @compounds.map { |compound| compound.payload&.dig("wada") }
        if flags.any? { |wada| wada.is_a?(Hash) && wada["prohibited"] == true }
          WadaRollup.new(status: "prohibited")
        elsif flags.any?(&:nil?)
          WadaRollup.new(status: "unknown")
        else
          WadaRollup.new(status: "not_prohibited")
        end
      end
  end
end
