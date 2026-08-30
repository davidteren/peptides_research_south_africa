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

  def primary_citation(compound)
    sources = Array(compound.payload&.dig("sources")).select { |source| source.is_a?(Hash) }
    preferred = sources.find { |source| %w[regulator primary_literature].include?(source["kind"]) }
    preferred ||= sources.find { |source| source["kind"] == "review" }
    return if preferred.blank?

    preferred["pmid"].presence || preferred["title"]
  end

  def ships_from_label(provider)
    country = provider.payload&.dig("country").to_s.strip
    return t("products.ships_from_unknown") if country.blank?

    if country.casecmp?("ZA")
      city = provider.city.presence
      return city ? t("products.ships_from_za_city", city: city) : t("products.ships_from_za")
    end

    t("products.ships_from_abroad", region: country)
  end

  def cold_chain_label(provider)
    case provider.payload&.dig("cold_chain")
    when true then t("products.cold_chain_yes")
    when false then t("products.cold_chain_no")
    else t("products.cold_chain_unknown")
    end
  end

  def listing_price_label(product)
    return t("products.price_unknown") unless product.price_zar.present? && product.price_visible_without_login?

    amount = format_listing_amount(product.price_zar)
    date = product.payload&.dig("price_checked_on")
    if date.present?
      t("products.price_as_of", amount: amount, date: date)
    else
      t("products.price_amount", amount: amount)
    end
  end

  private
    def format_listing_amount(value)
      number = BigDecimal(value.to_s)
      number.frac.zero? ? number.to_i : value
    end
end
