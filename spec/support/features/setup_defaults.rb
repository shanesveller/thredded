module Features
  def default_messageboard
    @messageboard ||= create(:messageboard, site: default_site)
  end

  def default_user
    @user ||= create(:user)
  end

  def default_site
    @default_site ||= create(:site, default_site: true)
  end

  alias create_default_messageboard default_messageboard
  alias create_default_user default_user
  alias create_default_site default_site
end
