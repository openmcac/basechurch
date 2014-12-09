basechurch
==========

[![Build Status](https://travis-ci.org/openmcac/basechurch-api.svg?branch=master)](https://travis-ci.org/openmcac/basechurch-api)
[![Code Climate](https://codeclimate.com/github/openmcac/basechurch-api/badges/gpa.svg)](https://codeclimate.com/github/openmcac/basechurch-api)
[![Test Coverage](https://codeclimate.com/github/openmcac/basechurch-api/badges/coverage.svg)](https://codeclimate.com/github/openmcac/basechurch-api)

Basechurch is a set of APIs for front-ends to interact with in order to save
data about their church and the groups inside it. The goal is to have one API
that a church's various platforms (iOS, Android, web) will fetch data from.

 - [Contribuing to Basechurch][contrib]

[contrib]: https://github.com/openmcac/basechurch-api/blob/master/CONTRIBUTING.md

### Getting Started

 - Set up repository

```bash
$ cd ~/repos                   # or wherever you want to store your code
$ git clone git@github.com:openmcac/basechurch-api
$ cd basechurch-api
$ bundle install               # install required gems
$ bundle exec rake db:migrate  # update database
```

 - [Set up application server][pow]

[pow]: http://pow.cx/manual.html#section_1

```bash
$ curl get.pow.cx | sh         # installs pow
$ cd ~/.pow
$ ln -s ~/repos/basechurch-api api.basechurch
```

 - Your application is now served at http://api.basechurch.dev

### Running Specs

You can run all specs with the following command:

```bash
$ cd ~/repos/basechurch-api
$ bundle exec rake db:migrate RAILS_ENV=test  # update test db
$ bundle exec rspec
```

You can also run specs automatically (TDD) with:

```bash
$ bundle exec guard
```

Make sure that all specs pass before submitting a Pull Request.
