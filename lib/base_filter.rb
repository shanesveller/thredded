module BaseFilter
  Filters = []

  def filters; Filters; end

  def filtered_content
    self.content
  end
end
