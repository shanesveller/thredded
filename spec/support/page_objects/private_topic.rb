module PageObject
  class PrivateTopic
    include Capybara::DSL
    include PageObject::Authentication
    include Rails.application.routes.url_helpers
    include FactoryGirl::Syntax::Methods

    def initialize(options={})
      @user_one     = options.fetch(:user_one) { create(:user) }
      @user_two     = options.fetch(:user_two) { create(:user) }
      @messageboard = options.fetch(:messageboard) { find_or_create_board }
      @title        = options.fetch(:title) { 'Secret topic' }
      @content      = options.fetch(:content) { 'Noone else can read this' }
    end

    def self.between(user_one, user_two)
      new(
        user_one: user_one,
        user_two: user_two,
      )
    end

    def create_through_site
      visit messageboard_topics_path(@messageboard)
      find('.new_private_topic a').click
      fill_in 'topic_title', with: @title
      select @user_two.name, from: 'topic_user_id'
      fill_in 'topic_posts_attributes_0_content', with: @content
      find('.submit input').click
    end

    def create_with_factory
      post = build(:post, content: @content, topic: nil)
      private_topic = create(:private_topic,
        title: @title,
        user: @user_one,
        users: [@user_one, @user_two],
        messageboard: @messageboard,
        posts: [post]
      )

      self
    end

    def listed?
      visit messageboard_private_topics_path(@messageboard)
      has_content?(@title)
    end

    def readable?
      topic = Topic.where(title: @title).first
      visit messageboard_topic_posts_path(@messageboard, topic)
      has_content?(@content)
    end

    def posts
      topic = Topic.where(title: @title).first
      visit messageboard_topic_posts_path(@messageboard, topic)
      all('article.post')
    end

    private

    def find_or_create_board
      Messageboard.first || create(:messageboard)
    end
  end
end
