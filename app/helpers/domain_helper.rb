module DomainHelper
  def default_domain
    Site.find_by_default_site(true).cached_domain
  end
end
