# Mebe


Mebe -- _the Minimalistic Elixir Blog Engine_ -- is a simple blog engine written in [Elixir](https://elixir-lang.org),
using the [Phoenix Framework](http://www.phoenixframework.org/).

The engine consists of two parts:

1. MebeEngine, which handles parsing the data files into an ETS (_Erlang Term Storage_) in-memory database, and
2. MebeWeb, which uses the Phoenix Framework to serve the blog data to clients.

## Installation for development

* `git clone`
* Copy `config/*.exs.dist`, removing the `.dist` ending and go through the configs.
* `npm install && gulp` to build the frontend.
* `mix phoenix.server` to run the development server.

## Features

* Blog by just writing Markdown files, no admin UI
* Automatic yearly, monthly and tag archives
* Disqus commenting
* RSS feeds for all posts and for tags
* Override templates by putting replacements into a directory
* Expect script for refreshing blog from the command line
* Splitting of posts so that only the beginning will be shown in a list view or feed

## Possible future features

* Tests
* User's guide
* Sitemap
* Override styles more easily

## Licence

Mebe is open source and licensed under the MIT Expat licence. Check the [LICENCE](LICENCE) file for details.
