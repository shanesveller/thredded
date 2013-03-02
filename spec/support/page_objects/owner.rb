require_relative './authentication'

module PageObject
  class Owner
    include Capybara::DSL
    include PageObject::Authentication
  end
end
