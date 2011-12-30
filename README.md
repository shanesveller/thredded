# Thredded

## Why?

Two reasons. The vast majority of messageboard, or "forum", software out there is garbage.  And I can't find any current and maintained projects running on Rails (specifically version 3).

## History

This project started years ago as a side project to keep busy while the first big dot-com stuff hit the fan and things on my plate at work got real lean. Back then this was built on PHP with Mysql - like many things. The users knew what they wanted and I wanted to be able to add features without digging through someone else's cess-pool of mangled code.  I wanted my *own* cess-pool of mangled code. 

Eventually I discovered RoR and re-developed everything with Rails.  That version was terrible.  

The second version?  Also terrible.  

So, that's right - this is it's 3rd Rails-based incarnation. This time with a full(-ish) test suite.


## An Admission

The Thredded code-base is by no means a pinnacle in software engineering.  I won't be winning any code-quality competitions anytime soon. However, I'm trying my damndest to iterate and improve everything in here constantly. The important thing right now is that this works well for its users and is fun to use.  What's under the hood _will_ get better. For those familiar with the theory of the human "lizard brain" you might notice this admission as my method to push aside the nagging voice and just put this out for people to use. 

Poke around the source and take a look. If there's anything that's been overlooked or approached with an ignorant eye, let me know and send me an email.  Or, even better (of course), fork, commit and send a pull request.  I'm open to any and all thoughts.

## Requirements:

* ImageMagick is installed
* postgres or mysql


## Features:

Whatever's stricken out still needs to be implemented

* Security per messageboard - private, public or logged in users only
* Permissions to post - anonymous, members or logged in users only
* <del>Attaching images to posts</del>
* <del>Attaching documents to posts</del>
* Content Filters - bbcode, textile
* Locking threads
* Sticky / Pinned threads
* Private threads
* <del>Fully theme'able</del>
* <del>Placement of attached images to posts</del>
* <del>Logging in via twitter, github, facebook, linked in, and Gmail</del>
* Search
* <del>Import and Export</del>


## Testing / Autotest:

* [Read the Installation instructions](https://github.com/jayroh/thredded/blob/master/INSTALL.md) to get it up and running locally.
* make sure you have `growlnotify` installed. That can be found [in Extras folder of the Growl dmg](http://growl.info/index.php)
* make sure to add the following line to your ~/.autotest file:

	`require 'autotest/growl'`

* start guard

	`guard start &`

* for just RSpec coverage from autotest

	`autotest`

* for both RSpec and Cucumber

	`AUTOFEATURE=true autotest`
