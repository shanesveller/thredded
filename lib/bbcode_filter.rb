module BbcodeFilter
  require "bb-ruby"
  
  def self.included(base)
    base.class_eval { Post::Filters << :bbcode }
  end

  def filtered_content
    if self.filter == :bbcode
     @filtered_content = self.content
     @filtered_content = @filtered_content.bbcode_to_html.html_safe if @filtered_content
    end
    true
  end
end

Post.send :include BbcodeFilter
