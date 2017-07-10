#!/bin/bash

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  up -d db

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  run -e RAILS_ENV=test web bundle exec rake db:create

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  run -e RAILS_ENV=test web bundle exec rake db:migrate

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  run web bundle exec rspec
