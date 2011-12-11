class PersonalizedDomain
  def matches?(request)

    main_site = Site.where("cached_domain = ? OR cached_domain = ?", "www.#{THREDDED[:default_domain]}", THREDDED[:default_domain]).first
    return true if main_site.present? and main_site.cached_domain == request.host

    case request.host
      when "www.#{THREDDED[:default_domain]}", "#{THREDDED[:default_domain]}", nil
        false
      else
        true
    end

  end
end
