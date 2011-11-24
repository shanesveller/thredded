def in_memory_database?
  Rails.env == "test" and 
  ActiveRecord::Base.connection.class == ActiveRecord::ConnectionAdapters::SQLiteAdapter || 
  ActiveRecord::Base.connection.class == ActiveRecord::ConnectionAdapters::SQLite3Adapter and 
  Rails.configuration.database_configuration['test']['database'] == ':memory:'
end

if in_memory_database?
  ActiveRecord::Schema.verbose = false
  load "#{Rails.root}/db/schema.rb"
end

