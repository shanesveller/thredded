source 'http://rubygems.org'

gem 'rails',            '3.0.3'
gem 'bson_ext',         '1.1.5'
gem 'mongo',            '1.1.5'
gem 'mongoid',          :git => 'git://github.com/mongoid/mongoid.git' , :branch => "refactor"
gem 'devise',           :git => "git://github.com/plataformatec/devise.git" 
gem 'cancan',           :git => "git://github.com/bowsersenior/cancan.git" # TODO: Once 1.5 is released switch to ryanb's master repo
gem 'compass'
gem 'rspec',            '2.3.0'
gem 'rspec-rails',      '2.3.1'
gem 'rails3-generators'
gem 'paperclip'
gem 'themes_for_rails' 
gem 'omniauth',         '0.1.6'

# Rack Middleware
gem 'rack-tidy'

# Deploy with Capistrano
gem 'capistrano'

# Test specific gems
group :test do
  gem 'autotest-standalone'
  gem 'autotest-growl'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'shoulda'
  gem 'cucumber',		'0.10.0'
  gem 'cucumber-rails',	'0.3.2'
  gem 'timecop'
  gem 'spork'
  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard-spork'
  gem 'launchy'
  gem 'fuubar'
end

# :development specific gems
group :development do
  gem 'ruby-debug'
  gem 'mongrel'

  # convenience gems
  gem 'wirble'
  gem 'hirb'
  gem 'awesome_print', :require => 'ap'
end
