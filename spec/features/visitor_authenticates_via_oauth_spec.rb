require 'spec_helper'

feature 'Visitor authenticates w/Oauth' do
  before do
    create_default_messageboard
  end

  scenario 'Signs up and signs in with GitHub' do
    visitor = the_new_visitor
    visitor.signs_up_via_github

    expect(visitor).to be_logged_in
    expect(visitor).to be_seeing_notice_to_link_account
  end

  scenario 'Signs in with GitHub and can link account' do
    visitor = the_new_visitor
    visitor.signs_up_via_github

    expect(visitor).to be_able_to_link_account
  end

  scenario 'Signs in with Github and links previous account' do
    user = the_previous_user
    visitor = the_new_visitor
    visitor.signs_up_via_github
    visitor.links_github_with_existing_account

    expect(visitor).to be_logged_in
    expect(visitor).to be_signed_in_as_previous_user
    expect(visitor).to_not be_able_to_link_account
  end

  scenario 'After linking account user should be able to log out and in with right account' do
    user = the_previous_user
    visitor = the_new_visitor
    visitor.signs_up_via_github
    visitor.links_github_with_existing_account
    visitor.signs_out
    visitor.signs_up_via_github
    visitor.goes_to_edit_account

    expect(visitor).to be_signed_in_as_previous_user
  end

  def the_previous_user
    @the_previous_user ||= create(:user, email: 'joel@example.com', password: 'password')
  end

  def the_new_visitor
    Visitor.new
  end

  class Visitor
    include Capybara::DSL
    include Rails.application.routes.url_helpers

    def links_github_with_existing_account
      visit edit_user_registration_path
      fill_in 'identity_email', with: 'joel@example.com'
      fill_in 'identity_password', with: 'password'
      find('#identity_submit').click
    end

    def signs_out
      visit '/users/sign_out'
    end

    def signs_up_via_github
      visit '/users/sign_in'
      find('a.github').click
    end

    def seeing_notice_to_link_account?
      has_content? 'If you would like to link'
    end

    def logged_in?
      has_css? 'header nav a', text: 'Logout'
    end

    def signed_in_as_previous_user?
      find('#user_email').value.should == 'joel@example.com'
    end

    def able_to_link_account?
      goes_to_edit_account
      has_css? 'legend', text: 'Link Your Account'
    end

    def goes_to_edit_account
      visit edit_user_registration_path
    end
  end
end
