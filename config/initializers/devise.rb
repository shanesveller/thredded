Devise.setup do |config|
  require 'devise/orm/active_record'

  if AppConfig.table_exists? && AppConfig.count > 0
    config.mailer_sender = AppConfig.first.email_from
  else
    config.mailer_sender = 'thredded@change-this-address.com'
  end

  config.authentication_keys = [:email]
  config.case_insensitive_keys = [:email]
  config.stretches = 10
  config.pepper = "9975f15b00a842d3c1b9528561a1cb5c7c7a0b826faff8039f5364c587afcc5e0b6a2152c613bd960ab3d4ac16ed255ec857a24d2a8905d7084b60fd969632c2"
  config.email_regexp = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
end
