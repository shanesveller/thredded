module TextileFilter

    def self.included(base)
      base.class_eval { Post::Filters << :textile }
      base.extend ClassMethods
    end
    
    def TextileFilter.render_content(content)
      RedCloth.new(content).to_html.html_safe
    end

end
