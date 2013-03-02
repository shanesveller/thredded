module PageObject
  class Setup
    include Capybara::DSL

    def initialize
      visit '/'
    end

    def return_to_step_one
      visit '/1'
    end

    def visit_step_two
      visit '/2'
    end

    def visit_step_three
      visit '/3'
    end

    def submit_step_one
      fill_in 'Username', with: 'joel'
      fill_in 'Email', with: 'joel@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Continue'
    end

    def submit_step_two
      fill_in 'Title', with: 'Messageboards'
      fill_in 'Description', with: 'another internet forum'
      fill_in 'Site Domain', with: 'www.example.com'
      fill_in 'site_email_from', with: 'board@example.com'
      fill_in 'site_email_subject_prefix', with: '[Board]'
      fill_in 'site_incoming_email_host', with: 'reply.example.com'
      click_button 'Continue'
    end

    def submit_step_three
      fill_in 'messageboard_title', with: 'chat'
      fill_in 'messageboard_name', with: 'Chat'
      fill_in 'messageboard_description', with: 'Talk about stuff'
      click_button 'Continue'
    end

    def on_step_one?
      has_css? 'form#new_user'
    end

    def on_step_two?
      has_css? 'form#new_site'
    end

    def on_step_three?
      has_css? 'form#new_messageboard'
    end

    def done?
      has_css? '#messageboards h2 a', text: 'chat'
    end
  end
end
