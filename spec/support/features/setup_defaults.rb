module Features
  def default_site
    @default_site ||= create(:site, default_site: true)
  end

  alias create_default_site default_site
end
