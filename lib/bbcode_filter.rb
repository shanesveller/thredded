module BbcodeFilter
    require "bb-ruby"
    
    def self.included(base)
      base.class_eval { Post::Filters << :bbcode }
    end

    # BbcodeFilter.render_content("This is [i]italic[/i].")
    def self.render_content(content)
      content.bbcode_to_html.html_safe if content
    end

end
