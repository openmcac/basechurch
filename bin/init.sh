#!/bin/bash

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  up -d db

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  run web rm /app/tmp/pids/server.pid

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  run web bundle exec rake db:create

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  run web bundle exec rake db:migrate

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  run web bundle exec rake db:seed

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  up -d
