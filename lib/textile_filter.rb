module TextileFilter

    def self.included(base)
      base.class_eval do
        Post::Filters << :textile
      end
    end

    def filtered_content
      @filtered_content = self.filter.to_sym == :textile ? RedCloth.new(super).to_html.html_safe : super
    end

end
