# Initial Setup

I highly suggest using [RVM](https://rvm.beginrescueend.com/) or [RBENV](https://github.com/sstephenson/rbenv) to manage your ruby runtimes. I'm going forward assuming that you will be using RVM so if more information is needed please take the time to way Ryan Bates' screencast on [getting started with Ruby on Rails](http://railscasts.com/episodes/310-getting-started-with-rails).

* Install Ruby 1.9.2 -- `rvm install 1.9.2`
* create a thredded gemset -- `rvm gemset create thredded`
* use your new thredded-specific ruby env -- `rvm use 1.9.3@thredded`

NOTE: You *could* use Ruby 1.9.3 as it's a bit faster but currently has [some issues with ruby-debug19](http://blog.wyeworks.com/2011/11/1/ruby-1-9-3-and-ruby-debug). If you don't plan on using that, then by all means go with 1.9.3 while taking into consideration that it is a relatively new release.

***

# Config Files

Before installing all the gem dependencies take note of which RDBMS you'll be using and adjust the Gemfile accordingly. The default is Postgres (the **_pg_** gem) but if you'd like to use Mysql you may comment out `gem 'pg'` and instead use the Mysql2 gem -- `gem 'mysql2'`

Two files remain that need to be created - **config/database.yml** and **config/thredded_config.yml**.  There are three sample files -- database.yml files for both pg and mysql, and one for thredded_config.yml -- in the repo but I'll include them here for a quick copy and paste job.  Create those two files and configure for your environment.

*_config/database.yml_* (for postgres)

	defaults: &defaults
	  adapter: postgresql
	  encoding: UTF8
	  host: localhost
	  port: 5432
	  
	development:
	  <<: *defaults
	  database: thredded_dev
	  username: username
	  password: password
	
	test:
	  <<: *defaults
	  database: thredded_test
	  username: username
	  password: password
	
	production:
	  <<: *defaults
	  database: thredded_production
	  username: username
	  password: password

*_config/database.yml_* (for mysql)

	defaults: &defaults
	  adapter: mysql2
	  encoding: utf8
	  reconnect: false
	  pool: 5
	  username: root
	  password: 
	  socket: /tmp/mysql.sock
	
	development:
	  <<: *defaults
	  database: thredded_dev
	  username: username
	  password: password
	
	test:
	  <<: *defaults
	  database: thredded_test
	  username: username
	  password: password
	
	test:
	  <<: *defaults
	  database: thredded_production
	  username: username
	  password: password


*_config/thredded_config.yml_*

	defaults: &defaults
	  site_name: "My Messageboard"
	  email: "My Messageboard Mail-Bot <noreply@mysite.com>"
	  subject_prefix: "[My Messageboard] "
	  default_messageboard_name: "default"
	  default_messageboard_home: "home"            # => home#index
	  # default_messageboard_home: "messageboards" # => messageboards#index
	  # default_messageboard_home: "topics"        # => messageboards#show where :messageboard_id == default_messageboard_name
	
	development:
	  domain: localhost:3000
	  address: http://localhost:3000
	  <<: *defaults
	
	test:
	  domain: test:3000
	  address: http://test:3000
	  <<: *defaults
	
	production:
	  domain: domain.com
	  address: http://domain.com
	  <<: *defaults

***

# Bootstrapping

Now that those two files are created and the settings are correct we can move on to creating the DB and seeding some data.

* create the database, migrate the tables and seed with your own data:

		rake db:create db:migrate db:bootstrap

  That should get everything situated in the database for you.
* **Note:** If you set your default messageboard's name to something other than "misc-topics" then make sure to change `default_messageboard_name` in _thredded_config.yml_ to the name of the board you entered during `rake db:bootstrap`.
* start the server with 

		rails s

  and you should be ready to go!

