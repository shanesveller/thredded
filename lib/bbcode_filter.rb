module BbcodeFilter

    require "bb-ruby"
    
    def self.included(base)
      base.class_eval { Post::Filters << :bbcode }
      base.extend ClassMethods
    end
    
    # module ClassMethods
    #   def hello
    #     "hi"
    #   end
    # end

    def BbcodeFilter.render_content(content)
      content.bbcode_to_html.html_safe
    end

    # def render_content
    #   content.bbcode_to_html.html_safe
    # end

end
