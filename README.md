# GeekPress


GeekPress -- _the Beautiful Minimalistic Elixir Blog for Geek_ -- is the simplest and fastest blog for geeks written in [Elixir](https://elixir-lang.org),
using the [Phoenix Framework](http://www.phoenixframework.org/).

This engine is forked from [Mebe Blog Engine](https://blog.nytsoi.net) and I have been adding some features to make it more useful for my blogging need. I also added the default wonderful theme _Medium-like_ so you can  enjoy your writting without choosing a good theme for it.

The engine consists of two parts:

1. MebeEngine, which handles parsing the data files into an ETS (_Erlang Term Storage_) in-memory database, and
2. MebeWeb, which uses the Phoenix Framework to serve the blog data to clients.

## Installation for development

* `git clone`
* Copy `config/*.exs.dist`, removing the `.dist` ending and go through the configs.
* `npm install && gulp` to build the frontend.
* `mix phoenix.server` to run the development server.

## Features that I added to GeekPress
* Default wonderful `Medium-like` theme.
* Allow multiple authors to contributes
* Show author information in each post with avatar.
* Change the structure of markdown parser to be like Yaml format like [Octopress](http://octopress.org/docs/blogging/).
* Add feature background images to top of blog.
* A User's guide to use this blog more easily.

## Default Features in Mebe

* Blog by just writing Markdown files, no admin UI.
* Automatic yearly, monthly and tag archives.
* Disqus commenting.
* RSS feeds for all posts and for tags.
* Override templates by putting replacements into a directory.
* Expect script for refreshing blog from the command line.
* Splitting of posts so that only the beginning will be shown in a list view or feed.

## Possible future features

* Author page
* Social network meta data and sharing for posts
* Tests
* Sitemap
* Override styles more easily

## Licence

Mebe is open source and licensed under the MIT Expat licence. Check the [LICENCE](LICENCE) file for details.
