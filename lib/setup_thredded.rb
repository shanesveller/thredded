class SetupThredded
  def matches?(request)
    return Setting.all.empty?
  end
end
