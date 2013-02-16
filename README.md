# Thredded [![Build Status](https://secure.travis-ci.org/jayroh/thredded.png?branch=master)](https://travis-ci.org/jayroh/thredded) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jayroh/thredded)

The vast majority of messageboard, or "forum", software out there is garbage. Either it's old, bloated or boring. Thredded is an effort to be a modern take on the forum/messageboard space with a modern stack, using modern methodologies - ruby, rails, pg, test-driven.

If you're looking for variations on a theme - see [Discourse], [Forem], [Tectura] or [Heterotic Beast]. The last two are forks from Rick Olsen and Courtenay's [Altered Beast]. Of those it should be noted that Forem is an engine - not a standalone app.

[Discourse]: http://www.discourse.org/
[Forem]: https://www.github.com/radar/forem
[Tectura]: https://github.com/caelum/tectura
[Heterotic Beast]: https://github.com/distler/heterotic_beast
[Altered Beast]: https://www.github.com/courtenay/altered_beast

## Installation:

If you just want to know how to install - please head to [the Installation instructions](https://github.com/jayroh/thredded/blob/master/INSTALL.md). Details on getting things running on Heroku are included.

## Requirements:

* postgres (search currently only works with pg, using pg's fulltext search capabilities)
* sendgrid (for incoming email)

## Features:

Whatever's stricken out still needs to be implemented

* Multi-tenanted - by full domain or subdomain.
* Security per messageboard - private, public or logged in users only
* Permissions to post - anonymous, members or logged in users only
* Attaching images to posts
* Attaching documents to posts
* Content Filters - bbcode, textile, markdown
* Locking topics
* Sticky / Pinned topics
* Private topics
* Placement of attached images to posts
* Logging in via github <del>twitter, facebook, linked in, and Gmail</del>
* Full-text search

## Testing w/Zeus

I prefer [zeus](https://github.com/burke/zeus) over spork. To run the test suite with zeus visit the zeus repo on github for how to do so: <https://github.com/burke/zeus>

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
