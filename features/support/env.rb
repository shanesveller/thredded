require 'cucumber/rails'
require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'
require 'factory_girl'
require 'factory_girl/step_definitions'
require 'timecop'
require 'email_spec'
require 'email_spec/cucumber'

FactoryGirl.definition_file_paths = [File.join(Rails.root, 'spec', 'factories')]
FactoryGirl.reload
World(FactoryGirl::Syntax::Methods)
Capybara.default_selector = :css
ActionController::Base.allow_rescue = false
