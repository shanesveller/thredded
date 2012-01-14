class SetupThredded
  def matches?(request)
    return User.all.empty? || Site.all.empty? || Messageboard.all.empty?
  end
end
