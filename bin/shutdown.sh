#!/bin/bash

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  down

docker-compose \
  -f apps/landing/docker-compose.yml \
  -f apps/landing/docker-compose.override.yml \
  down

