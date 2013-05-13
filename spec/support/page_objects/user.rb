module PageObject
  class User
    include Capybara::DSL
    include PageObject::Authentication
    include Rails.application.routes.url_helpers
    include FactoryGirl::Syntax::Methods

    attr_accessor :user

    def user(name='user', email='user@example.com')
      @user = create(:user, name: name, email: email, password: 'password')
      self
    end

    def log_in(name='me', email='me@example.com')
      @user = create(:user, name: name, email: email, password: 'password')
      visit new_user_session_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      self
    end

    def create_topic(title)
      board = create(:messageboard, name: 'yup')
      topic = create(:topic,
        user: @user,
        title: title,
        messageboard: board,
      )
    end

    def create_private_topic(title)
      board = create(:messageboard, name: 'yup')
      topic = create(:private_topic,
        user: @user,
        title: title,
        messageboard: board,
      )
    end

    def create_unreadable_topic_in_private_messageboard(title)
      board = create(:messageboard, :private, name: 'private')
      topic = create(:topic,
        user: @user,
        title: title,
        messageboard: board,
      )
    end

    def load_page
      visit user_path(@user)
    end

    def displaying_the_profile?
      has_content?(@user.name)
    end

    def has_topic?(title)
      has_content?(title)
    end

    def has_redirected_with_error?
      has_content?("No user exists named #{@user.name}")
    end
  end
end
