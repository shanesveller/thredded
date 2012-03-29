module MarkdownFilter
  
  def self.included(base)
    base.class_eval do
      Post::Filters << :markdown
    end
  end

  def filtered_content
    if self.filter.to_sym == :markdown
      renderer = Redcarpet::Render::HTML.new(:hard_wrap => true, :filter_html => true)
      markdown = Redcarpet::Markdown.new(renderer, :autolink => true, :space_after_headers => true)
      @filtered_content = markdown.render(super).html_safe
    else
      return super
    end
  end

end
