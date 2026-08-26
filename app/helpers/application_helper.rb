module ApplicationHelper
  def catalog_routes(compound)
    Array(compound.payload&.dig("routes_studied")).join(", ").presence || "—"
  end

  def evidence_grade_label(grade)
    t("grades.#{grade}", default: grade.to_s.humanize)
  end

  def provider_kind_label(kind)
    t("kinds.#{kind}", default: kind.to_s.humanize)
  end
end
