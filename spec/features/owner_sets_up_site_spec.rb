require 'spec_helper'
require_relative '../support/page_objects/owner'
require_relative '../support/page_objects/setup'

feature 'Setting up the site' do
  scenario 'bootstraps the app' do
    setup = setup_the_site
    owner = the_site_owner

    setup.submit_step_one
    expect(setup).to be_on_step_two

    setup.submit_step_two
    expect(setup).to be_on_step_three

    setup.submit_step_three
    expect(setup).to be_done
    expect(owner).to be_logged_in
  end

  scenario 'cannot skip to step two' do
    setup = setup_the_site

    setup.visit_step_two

    expect(setup).to be_on_step_one
    expect(setup).to_not be_on_step_two
  end

  scenario 'cannot skip to step three' do
    setup = setup_the_site

    setup.visit_step_three

    expect(setup).to be_on_step_one
    expect(setup).to_not be_on_step_three
  end

  scenario 'cannot return to step one' do
    setup = setup_the_site

    setup.submit_step_one
    setup.return_to_step_one

    expect(setup).to be_on_step_two
    expect(setup).to_not be_on_step_one
  end

  scenario 'cannot return to step two' do
    setup = setup_the_site

    setup.submit_step_one
    setup.submit_step_two
    setup.return_to_step_one

    expect(setup).to be_on_step_three
    expect(setup).to_not be_on_step_one
    expect(setup).to_not be_on_step_two
  end

  def setup_the_site
    PageObject::Setup.new
  end

  def the_site_owner
    PageObject::Owner.new
  end
end
