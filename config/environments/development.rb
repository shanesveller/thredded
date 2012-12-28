Thredded::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default charset: 'utf-8'

  %w[topic private_topic].each do |c|
    require_dependency File.join('app','models',"#{c}.rb")
  end
end
