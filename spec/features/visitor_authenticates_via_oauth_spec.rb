require 'spec_helper'

feature 'Logging in w/Oauth' do
  before do
    create_default_messageboard
  end

  scenario 'Signs up and signs in with GitHub' do
    visitor = the_new_visitor
    visitor.signs_up_via_github

    expect(visitor).to be_logged_in
  end

  def the_new_visitor
    Visitor.new
  end

  class Visitor
    include Capybara::DSL

    def signs_up_via_github
      visit '/users/sign_in'
      find('a.github').click
    end

    def logged_in?
      has_css? 'header nav a', text: 'Logout'
    end
  end
end
