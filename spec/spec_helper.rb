require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  # Don't need passwords in test DB to be secure, but we would like 'em to be
  # fast -- and the stretches mechanism is intended to make passwords
  # computationally expensive.
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

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  counter = -1
  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.mock_with :mocha
    config.use_transactional_fixtures = false

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
  end # of RSpec.configure
end # of Spork.prefork

Spork.each_run do
  ActiveRecord::Schema.verbose = false
  load "#{Rails.root}/db/schema.rb"
  FactoryGirl.definition_file_paths = [File.join(Rails.root, 'spec', 'factories')]
  FactoryGirl.reload
end
