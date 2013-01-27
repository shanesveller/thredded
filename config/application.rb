require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "carrierwave"

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require *Rails.groups(:assets) if defined?(Bundler)


module Thredded
  mattr_accessor :themes
  self.themes = {}

  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('app').to_s
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]


    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    config.active_record.observers = :post_observer, :topic_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure generators values. Many other options are available, be sure to check the documentation.
    config.generators do |g|
      g.stylesheets         false
      g.orm                 :active_record
      g.template_engine     :erb
      g.test_framework      :rspec, :fixture => true,
                            :views => false,
                            :fixture => true
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

    # Asset Pipeline
    config.assets.enabled = true
    config.assets.initialize_on_precompile = false

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w(rails)
    # config.action_view.javascript_expansions[:jquery]   = ["jquery", "jquery-ui"]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Send the devise mailer class our domain helper
    config.to_prepare do
      Devise::Mailer.class_eval do
        helper :domain
      end
    end

    ### Part of a Spork hack. See http://bit.ly/arY19y
    if Rails.env.test?
      initializer :after => :initialize_dependency_mechanism do
        # Work around initializer in railties/lib/rails/application/bootstrap.rb
        ActiveSupport::Dependencies.mechanism = :load
      end
    end
  end
end

ActionDispatch::Callbacks.after do
  # Reload the factories
  return unless (Rails.env.test?)

  unless FactoryGirl.factories.blank?
    FactoryGirl.definition_file_paths = [File.join(Rails.root, 'spec', 'factories')]
    FactoryGirl.reload
  end
end
