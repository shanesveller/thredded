module TextileFilter

    def self.included(base)
      base.class_eval { Post::Filters << :textile }
    end

    # TextileFilter.render_content("_omg hi_!")
    def self.render_content(content)
      RedCloth.new(content).to_html.html_safe
    end

end
