# Load the rails application
require File.expand_path('../application', __FILE__)

raise 'config/thredded_config.yml does not exist. Please create or copy from thredded_config_sample.yml' unless FileTest.exists?(Rails.root.to_s + "/config/thredded_config.yml")

# Initialize the rails application
Thredded::Application.initialize!
