# Setup

I suggest using [RVM] or [RBENV] to manage your ruby VMs. I will assume you are
using RVM, so if more information is needed please take the time to watch Ryan
Bates' screencast on [getting started with Ruby on Rails].

[RVM]:https://rvm.beginrescueend.com/
[RBENV]:https://github.com/sstephenson/rbenv
[getting started with Ruby on Rails]:http://railscasts.com/episodes/310-getting-started-with-rails

* Install Ruby 1.9.3 -- `rvm install 1.9.3`
* Install imagemagick, preferably with homebrew -- `brew install imagemagick`

***

## Configuration

Your database config needs to be created - `config/database.yml`. There is a
sample `database.yml` file for pg. Copy one of those two files to
**config/database.yml** and configure for your environment & database.

**NOTE:** Because of the use of Postgres's full-text search capabilities in the
source, Thredded no longer supports mysql out of the box.

*_config/database.yml_*

```
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
```

***

## Setup

* Install the gem dependencies with

    bundle install

* Create the database, migrate the tables and seed with your own data:

    bundle exec rake db:create db:migrate db:test:prepare

* start the server with

    rails s

* Open your local server up in your browser and follow the setup "wizard". That will help you set up your site and first messageboard

## Heroku <a name="heroku"></a>

* use the cedar stack - `heroku create -s cedar`
* once your slug is compiled just visit the URL that heroku provides you and start the setup from right there.
