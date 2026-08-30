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

  def registered_medicine_label(value)
    case value
    when true then t("compounds.sahpra_registered_yes")
    when false then t("compounds.sahpra_registered_no")
    else t("compounds.sahpra_registered_unknown")
    end
  end

  def wada_prohibited_label(prohibited)
    if prohibited
      t("compounds.wada_prohibited")
    else
      t("compounds.wada_not_prohibited")
    end
  end

  def payload_date(hash, key = "verified_on")
    hash&.dig(key)
  end

  def non_sa_shipper?(provider)
    country = provider.payload&.dig("country").to_s.strip
    country.present? && !country.casecmp?("ZA")
  end
end
