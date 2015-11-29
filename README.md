# GeekPress


GeekPress -- _the Beautiful Minimalistic Elixir Blog for Geek_ -- is the simplest and fastest blog for geeks written in [Elixir](https://elixir-lang.org),
using the [Phoenix Framework](http://www.phoenixframework.org/).

Want to see DEMO IN ACTION? Try my blog [GeekVN](https://geekvn.com).

This engine is forked from [Mebe Blog Engine](https://blog.nytsoi.net/mebe) and I have been adding some features to make it more useful for my blogging need. I also added the default wonderful theme _Medium-like_ so you can enjoy your writting without the need of choosing a good theme for it.

The engine consists of two parts:

1. MebeEngine, which handles parsing the data files into an ETS (_Erlang Term Storage_) in-memory database, and
2. MebeWeb, which uses the Phoenix Framework to serve the blog data to clients.

## Features that I added to GeekPress

### Nov 25, 2015
* Default wonderful `Medium-like` theme.
* Allow multiple authors to contributes
* Show author information in each post with avatar.
* Change the structure of markdown parser to be like Yaml format like [Octopress](http://octopress.org/docs/blogging/).
* Add feature background images to top of blog.

### Nov 26, 2015
* Add a Dockerfile to build images automatically, so you can easily deploy without worring about the source code.

### Nov 28, 2015
* Add `force_ssl` option in config so you can force always redirect to ssl or not.
* Add `force_accurate_host` option in config so you can force to redirect to the host in config.
* Add `blog_favicon` option in config so you can config favicon for your blog.
* Add `nav_links` option in config so you can config navigation links on top of the blog.
* Add config for `github`, `facebook`, `twitter` account links at footer of blog.

### Nov 29, 2015
* Add `description` header for posts and pages markdown.
* Add Social network Open Graph meta data.
* Add Social Buttons: HackerNews, Twitter and Facebook, you can now share posts and pages!

## Installation for development

* `git clone`
* Copy `config/*.exs.dist`, removing the `.dist` ending and go through the configs.
* `npm install && gulp` to build the frontend.
* `mix phoenix.server` to run the development server.

## To Do Features

* Author pages.
* User guides

## Default Features in Mebe

* Blog by just writing Markdown files, no admin UI.
* Automatic yearly, monthly and tag archives.
* Disqus commenting.
* RSS feeds for all posts and for tags.
* Override templates by putting replacements into a directory.
* Expect script for refreshing blog from the command line.
* Splitting of posts so that only the beginning will be shown in a list view or feed.


## Licence

Mebe is open source and licensed under the MIT Expat licence. Check the [LICENCE](LICENCE) file for details.
