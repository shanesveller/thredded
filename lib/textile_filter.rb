module TextileFilter

    def self.included(base)
      base.class_eval { Post::Filters << :textile }
    end

    def filtered_content
      if self.filter == :textile
        @filtered_content = self.content
        @filtered_content = RedCloth.new(@filtered_content).to_html.html_safe if @filtered_content
      end
    end

end

Post.send :include TextileFilter
