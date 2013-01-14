ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'bourne'
require 'database_cleaner'
require 'factory_girl_rails'
require 'shoulda-matchers'
require 'chronic'
require 'timecop'

module Devise
  module Models
    module DatabaseAuthenticatable
      protected
      def password_digest(password)
        password
      end
    end
  end
end

Devise.setup do |config|
  config.stretches = 0
end

Dir[Rails.root.join('spec/support/**/*.rb')].each {|file| require file }

counter = -1

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.mock_with :mocha
  config.use_transactional_fixtures = false
  config.include Features, type: :feature

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.after(:suite) do
    counter = 0
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    counter += 1
    if counter > 9
      GC.enable
      GC.start
      GC.disable
      counter = 0
    end
  end

  ActiveSupport::Dependencies.clear
end
