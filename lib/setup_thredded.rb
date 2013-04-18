class SetupThredded
  def matches?(request)
    return User.all.empty? || AppConfig.all.empty? || Messageboard.all.empty?
  end
end
