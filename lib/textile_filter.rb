module TextileFilter

    def self.included(base)
      base.class_eval { Post::Filters << :textile }
      base.extend ClassMethods
    end

    module ClassMethods
      def render_content(content)
        RedCloth.new(content).to_html.html_safe
      end
    end

    def render_content(content)
      RedCloth.new(content).to_html.html_safe
    end

end
