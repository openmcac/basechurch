Basechurch
==========

[![Build Status](https://travis-ci.org/openmcac/basechurch.svg?branch=master)](https://travis-ci.org/openmcac/basechurch)
[![Code Climate](https://codeclimate.com/github/openmcac/basechurch/badges/gpa.svg)](https://codeclimate.com/github/openmcac/basechurch)
[![Coverage Status](https://coveralls.io/repos/openmcac/basechurch/badge.png)](https://coveralls.io/r/openmcac/basechurch)

Basechurch is a set of APIs for front-ends to interact with in order to save
data about their church and the groups inside it. The goal is to have one API
that a church's various platforms (iOS, Android, web) will fetch data from.

 - [Contributing to Basechurch][contrib]

[contrib]: https://github.com/openmcac/basechurch/blob/master/CONTRIBUTING.md

### Getting Started

 - Set up repository

```bash
$ cd ~/repos                        # or wherever you want to store your code
$ git clone git@github.com:openmcac/basechurch
$ cd basechurch
$ bundle install --without staging  # install required gems
$ bundle exec rake db:migrate       # update database
$ cd spec/test_app
$ bundle exec rake db:seed          # populate test data
```

 - [Set up application server][pow]

[pow]: http://pow.cx/manual.html#section_1

```bash
$ curl get.pow.cx | sh         # installs pow
$ cd ~/.pow
$ ln -s ~/repos/basechurch/spec/test_app basechurch
```

 - Your application is now served at http://basechurch.dev

### Running Specs

You can run all specs with the following command:

```bash
$ cd ~/repos/basechurch
$ RAILS_ENV=test bundle exec rake db:migrate  # update test db
$ bundle exec rspec
```

You can also run specs automatically (TDD) with:

```bash
$ cd ~/repos/basechurch
$ bundle exec guard
```

Make sure that all specs pass before submitting a Pull Request.
