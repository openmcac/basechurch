#!/bin/bash

docker-compose \
  -f apps/landing/docker-compose.yml \
  -f apps/landing/docker-compose.override.yml \
  -f apps/landing/docker-compose.test.yml \
  up -d redis

docker-compose \
  -f apps/landing/docker-compose.yml \
  -f apps/landing/docker-compose.override.yml \
  -f apps/landing/docker-compose.test.yml \
  run landing mvn test

