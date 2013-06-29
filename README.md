# Thredded [![Build Status](https://secure.travis-ci.org/jayroh/thredded.png?branch=master)](https://travis-ci.org/jayroh/thredded) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jayroh/thredded)

The vast majority of messageboard, or "forum", software out there is garbage. Either it's old, bloated or boring. Thredded is an effort to be a modern take on the forum/messageboard space with a modern stack, using modern methodologies - ruby, rails, pg, test-driven.

If you're looking for variations on a theme - see [Discourse], [Forem], [Tectura] or [Heterotic Beast]. The last two are forks from Rick Olsen and Courtenay's [Altered Beast]. Of those it should be noted that Forem is an engine - not a standalone app.

[Discourse]: http://www.discourse.org/
[Forem]: https://www.github.com/radar/forem
[Tectura]: https://github.com/caelum/tectura
[Heterotic Beast]: https://github.com/distler/heterotic_beast
[Altered Beast]: https://www.github.com/courtenay/altered_beast

## Demo

Check out [thredded.com](https://www.thredded.com/) for a live demo or [check out a few screenshots](http://imgur.com/a/CZ277).

<a href="http://imgur.com/7X0Wrh9"><img src="http://i.imgur.com/7X0Wrh9.png" title="" alt="" /></a>

## Installation:

If you just want to know how to install - please head to [the Installation instructions](https://github.com/jayroh/thredded/blob/master/INSTALL.md). Details on getting things running on Heroku are included.

## Requirements:

* Postgres. Search currently only works with pg, using pg's fulltext search capabilities.

## Optional:

* SendGrid. For incoming email thredded has built-in support for the SendGrid parse api using [griddler](https://github.com/thoughtbot/griddler).
* Resque. Emails will be queued thanks to the `resque_mailer` gem if you add the [thredded_resque](https://github.com/jayroh/thredded_resque) gem to thredded's Gemfile.

## Features:

Stricken text must still be implemented.

* Security per messageboard - private, public or logged in users only
* Permissions to post - anonymous, members or logged in users only
* Attaching images to posts
* Attaching documents to posts
* Content Filters - bbcode, markdown
* Locking topics
* Sticky / Pinned topics
* Private topics
* Placement of attached images to posts
* Logging in via github <del>twitter, facebook, linked in, and Gmail</del>
* Full-text search

## Deploying

The following are the ENV's that need to be set for deployment.

* `ENV['GOOGLE_ANALYTICS_ID']` - eg: 'UA-#######-1'
* `ENV['GITHUB_ID']` - for authentication via github, using omniauth, you'll need an app set up. Place the ID here...
* `ENV['GITHUB_SECRET']` - ... and the secret.
* `ENV['SECRET_TOKEN']` - the application secret token needs to be generated for environments other than test and development. See `./config/initializers/secret_token.rb`
* `ENV['CANONICAL_HOST']` - if set this will use *rack-canonical-host* to redirect requests to one canonical host

## Contributing

Everyone loves pull requests. Here are some guidelines:

1. Fork the repo.
2. Run the tests. Only pull requests with passing tests will be accepted, and it's great
   to know that you have a clean slate: `bundle && rake`
3. Add a test for your change. Only refactoring and documentation changes
   require no new tests. If you are adding functionality or fixing a bug, it needs
   a test!
4. Make the test pass.
5. I prefer that code adheres to the
   [thoughtbot Style Guide](https://github.com/thoughtbot/guides/tree/master/style)
   so take a look there, or know that I might refer to it in PR's. :)
6. Push to your fork and submit a pull request.

## Thanks / Acknowledgements

* Shaun @thedudewiththething
* Jim @saturnflyer
* Caleb @calebthompson
* Gabe @gabrielpreston
* Christian @christianmadden
* Jacob @jacobbednarz
* Jeffrey @semanticart
* Nick @qrush
* The entire MI, JA, LGN and MWA crews (thank you all)
