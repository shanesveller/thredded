# Thredded [![Build Status](https://secure.travis-ci.org/jayroh/thredded.png?branch=master)](https://travis-ci.org/jayroh/thredded) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jayroh/thredded)

## Installation:

If you just want to know how to install - please head to [the Installation instructions](https://github.com/jayroh/thredded/blob/master/INSTALL.md). Details on getting things running on Heroku are included.

## Why?

Two reasons. The vast majority of messageboard, or "forum", software out there is garbage.  And I can't find any current and maintained projects running on Rails (specifically version 3).

## History

This project started years ago as a side project to keep busy while the first big dot-com stuff hit the fan and things on my plate at work got real lean. Back then this was built on PHP with Mysql - like many things. The users knew what they wanted and I wanted to be able to add features without digging through someone else's cess-pool of mangled code.  I wanted my *own* cess-pool of mangled code.

Eventually I discovered RoR and re-developed everything with Rails.  That version was terrible.

The second version?  Also terrible.

So, that's right - this is it's 3rd Rails-based incarnation. This time with a full(-ish) test suite.

## Requirements:

* postgres (search currently only works with pg, using pg's fulltext search capabilities)
* sendgrid (for incoming email)

## Features:

Whatever's stricken out still needs to be implemented

* Security per messageboard - private, public or logged in users only
* Permissions to post - anonymous, members or logged in users only
* Attaching images to posts
* Attaching documents to posts
* Content Filters - bbcode, textile
* Locking threads
* Sticky / Pinned threads
* Private threads
* Fully theme'able
* Placement of attached images to posts
* <del>Logging in via twitter, github, facebook, linked in, and Gmail</del>
* Search
* <del>Import and Export</del>


## Speeding Up Tests

Using [zeus](https://github.com/burke/zeus) now instead of Spork/Guard. Run `zeus start` in a separate terminal. Switch to your active terminal while zeus is running in that separate terminal and ..

To run the entire suite you can run `zeus rake`, and for either rspec or cucumber `zeus rake spec` and `zeus rake cucumber` respectively.

For more information visit the zeus repo on github : <https://github.com/burke/zeus>
