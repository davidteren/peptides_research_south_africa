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

  def needs_review?(date)
    return false if date.blank?

    date.to_date < Date.current - 90
  end

  def checked_stamp(date, id:)
    return if date.blank?

    checked = content_tag(:p, t("compounds.checked", date: date.to_date.iso8601), id: id, class: "mt-1 text-sm text-stone-600")
    return checked unless needs_review?(date)

    review_id = id.to_s.sub("-checked", "-needs-review")
    safe_join([
      checked,
      content_tag(:p, t("compounds.needs_review"), id: review_id, class: "mt-1 text-sm text-stone-600")
    ])
  end

  def browse_chip_path(key, value)
    next_params = request.query_parameters.slice("q", "route", "form", "classification", "provider_kind")
    if next_params[key] == value
      next_params.delete(key)
    else
      next_params[key] = value
    end
    compounds_path(next_params)
  end

  def browse_chip_current?(key, value)
    params[key].to_s == value
  end

  def browse_filters_present?
    params[:route].present? || params[:form].present? || params[:classification].present? || params[:provider_kind].present?
  end

  def missing_alias_report_url(query)
    "https://github.com/davidteren/peptides_research_south_africa/issues/new?title=#{ERB::Util.url_encode("Missing alias: #{query}")}"
  end
end
