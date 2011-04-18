module PostsHelper

  def render_content_for(post)
    filter = post.filter
    begin
      mojule = Module::const_get filter.to_s.capitalize+"Filter"
      eval "#{mojule}.render_content(post.content)"
    rescue NameError
      BbcodeFilter.render_content(post.content) # default it to BBcode
    end
  end

end
