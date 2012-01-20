class PersonalizedDomain
  def matches?(request)

    main_site = Site.find_by_default_site(true)

    if main_site && main_site.home == "homepage"
      return false
    end

    if main_site.present? and main_site.cached_domain == request.host and main_site.messageboards.size > 0
      return true 
    end

    case request.host
      when "www.#{main_site.cname_alias}", main_site.cname_alias, nil
        false
      else
        true
    end

  end
end
