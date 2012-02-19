source 'http://rubygems.org'

# pick your database
gem 'pg'
# gem 'mysql2'

gem 'rack'
gem 'rake'                        , '0.9.2.2'
gem 'rails'                       , '3.1.3'
gem 'devise'                      , '1.5.3'
gem 'cancan'                      , '1.6.4'
gem 'mini_magick'                 , '3.2.1'
gem 'carrierwave'                 , '0.5.8'
gem 'nested_form'                 , :git => 'git://github.com/ryanb/nested_form.git'
gem 'rspec'                       , '2.6.0'
gem 'rspec-rails'                 , '2.6.1'
gem 'rails3-generators'
gem 'gravtastic'                  , '3.1.0'
gem 'nokogiri'                    , '1.5.0'
gem 'kaminari'                    , '0.12.4'
gem 'bb-ruby'                     , '0.9.5'
gem 'RedCloth'                    , '4.2.9' # in OS X Lion : gem install RedCloth -- --with-cflags=-w 
gem 'highline'                    , '1.6.1'
gem 'escape_utils'                , '0.2.3'
gem 'refraction'
gem 'multi_json'
gem 'client_side_validations'
gem 'thin'
gem 'thredded-theme-metal'        , :git => 'git://github.com/jayroh/thredded-theme-metal.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'jquery-rails'
  gem 'sass-rails', "3.1.0"
  gem 'uglifier'
  gem 'compass'
end

# Test specific gems
group :test, :cucumber do
  gem 'rack-test'           , :git => 'git://github.com/hassox/rack-test.git'
  gem 'autotest-standalone' , '4.5.9'
  gem 'autotest-growl'      , '0.2.16'
  gem 'factory_girl'        , '1.3.3'
  gem 'factory_girl_rails'  , '1.0.1'
  gem 'database_cleaner'  
  gem 'capybara'            , '1.1.2'
  gem 'shoulda'             , '2.11.3'
  gem 'cucumber'            , '1.1.4'
  gem 'cucumber-rails'      , '1.2.1', require: false
  gem 'timecop'
  gem 'spork'               , '~> 0.9.0.rc'
  gem 'growl'               , '1.0.3'
  gem 'rb-fsevent'
  gem 'guard-spork'         , '0.2.1'
  gem "addressable"         , "2.2.6"
  gem 'launchy'             , '2.0.5'
  gem 'fuubar'
end

# :development specific gems
group :development do
  gem 'ruby-debug-base19', '0.11.26' # https://gist.github.com/1848409 to work with 1.9.3-p125
  gem 'ruby-debug19', '0.11.6'
  gem 'guard-livereload'
  gem 'faker'
  gem 'heroku'
  gem 'foreman'

  # convenience gems
  gem 'wirble'
  gem 'hirb'
  gem 'awesome_print', :require => 'ap'
end
