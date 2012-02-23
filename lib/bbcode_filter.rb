module BbcodeFilter
  require "bb-ruby"
  
  def self.included(base)
    base.class_eval do
      Post::Filters << :bbcode
    end
  end

  def filtered_content
    @filtered_content = self.filter.to_sym == :bbcode ? super.bbcode_to_html.html_safe : super
  end

end
