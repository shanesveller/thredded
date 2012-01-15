require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

After do |scenario|
  DatabaseCleaner.clean
end

# AfterConfiguration do |config|
#   unless @after_conf
#     THREDDED = Hash.new 
#     THREDDED[:site_name] = "My Messageboard Site"
#   else
#     @after_conf = true
#   end
# end
