#!/bin/bash

docker-compose \
  -f apps/basechurch/docker-compose.yml \
  -f apps/basechurch/docker-compose.override.yml \
  down

