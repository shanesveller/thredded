module BbcodeFilter

    require "bb-ruby"
    
    def self.included(base)
      base.class_eval { Post::Filters << :bbcode }
      base.extend ClassMethods
    end
    
    module ClassMethods
      def render_content(content)
        content.bbcode_to_html.html_safe
      end
    end

    def render_content
      content.bbcode_to_html.html_safe
    end

end
