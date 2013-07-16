ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'bourne'
require 'database_cleaner'
require 'factory_girl_rails'
require 'shoulda-matchers'
require 'chronic'
require 'timecop'

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |file| require file }

counter = -1

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:github] = {
  'uid' => '12345',
  'provider' => 'github',
  'info' => {
    'email' => 'foo@example.com',
    'nickname' => 'foobar',
    'name' => 'Foo Bar'
  }
}

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.mock_with :mocha
  config.use_transactional_fixtures = false
  config.include Features, type: :feature
  config.treat_symbols_as_metadata_keys_with_true_values = true

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
