class PersonalizedDomain
  def matches?(request)
    case request.host
      when "www.#{THREDDED[:default_domain]}", "#{THREDDED[:default_domain]}", nil
        false
      else
        true
    end
  end
end
