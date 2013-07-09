require File.expand_path('../boot', __FILE__)
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_resource/railtie'
require 'sprockets/railtie'
require 'carrierwave'

if defined?(Bundler)
  Bundler.require(*Rails.groups(assets: %w(development test)))
end

module Thredded
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/app)
    config.autoload_paths += %W(#{config.root}/app/decorators)
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.time_zone = 'UTC'

    config.generators do |g|
      g.stylesheets         false
      g.orm                 :active_record
      g.template_engine     :erb
      g.test_framework      :rspec, fixture: true, views: false, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    config.assets.enabled = true
    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
    config.assets.precompile += %w(.svg .eot .woff .ttf)
    config.assets.precompile += %w(head.js)
    config.assets.initialize_on_precompile = false
    config.assets.version = '1.0'

    config.action_view.javascript_expansions[:defaults] = %w(rails)
    config.encoding = 'utf-8'
    config.filter_parameters += [:password, :password_confirmation]
  end
end

ActionDispatch::Callbacks.after do
  if Rails.env.test? && !FactoryGirl.factories.blank?
    FactoryGirl.definition_file_paths = [File.join(Rails.root, 'spec', 'factories')]
    FactoryGirl.reload
  end
end
