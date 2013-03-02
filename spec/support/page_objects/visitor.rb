require_relative './authentication'

module PageObject
  class Visitor
    include Capybara::DSL
    include PageObject::Authentication
    include Rails.application.routes.url_helpers

    def links_github_with_existing_account
      visit edit_user_registration_path
      fill_in 'identity_email', with: 'joel@example.com'
      fill_in 'identity_password', with: 'password'
      find('#identity_submit').click
    end

    def seeing_notice_to_link_account?
      has_content? 'If you would like to link'
    end

    def signed_in_as_previous_user?
      find('#user_email').value.should == 'joel@example.com'
    end

    def able_to_link_account?
      goes_to_edit_account
      has_css? 'legend', text: 'Link Your Account'
    end
  end
end
