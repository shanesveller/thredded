# Initial Setup

(for heroku - see [the bottom of this file](#heroku))

I highly suggest using [RVM](https://rvm.beginrescueend.com/) or [RBENV](https://github.com/sstephenson/rbenv) to manage your ruby vm's. I'll assume you're using RVM, so if more information is needed please take the time to watch Ryan Bates' screencast on [getting started with Ruby on Rails](http://railscasts.com/episodes/310-getting-started-with-rails). You should probably watch it anyway.

* Install Ruby 1.9.3 -- `rvm install 1.9.3`
* Install imagemagick, preferably with homebrew -- `brew install imagemagick`
* create a thredded gemset -- `rvm gemset create thredded`
* use your new thredded-specific ruby env -- `rvm use 1.9.2@thredded`

NOTE: You **could** use Ruby 1.9.3 as it's a bit faster but currently has [some issues with ruby-debug19](http://blog.wyeworks.com/2011/11/1/ruby-1-9-3-and-ruby-debug). If you don't plan on using that, then by all means go with 1.9.3 while taking into consideration that it is a relatively new release.

***

# Config Files

Before installing all the gem dependencies take note of which RDBMS you'll be using and adjust the Gemfile accordingly. The default is Postgres (the **_pg_** gem) but if you'd like to use Mysql you may comment out `gem 'pg'` and instead use the Mysql2 gem -- `gem 'mysql2'`

One more file needs to be created - **config/database.yml**. There are two sample database.yml files for both pg and mysql. Copy one of those two files to **config/database.yml** and configure for your environment & database.

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

***

# Setup

Now that those two files are created and the settings are correct we can move on to installing the gems, creating the DB and getting set up.

* Install the gems with 

		bundle install

* create the database, migrate the tables and seed with your own data:

		bundle exec rake db:create db:migrate

* and for your testing environment

		RAILS_ENV=test bundle exec rake db:create db:migrate

* start the server with 

		rails s

* Open your local server up in your browser and follow the setup "wizard". That will help you set up your site and first messageboard, and you should be ready to go!

## Heroku <a name="heroku"></a>

* use the cedar stack - `heroku create -s cedar`
* once your slug is compiled just visit the URL that heroku provides you and start the setup from right there.