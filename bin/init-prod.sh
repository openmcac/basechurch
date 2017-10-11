#!/bin/bash

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  up -d db

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  run api rm /app/tmp/pids/server.pid

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  run api bundle exec rake db:create db:migrate db:seed

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  up -d

