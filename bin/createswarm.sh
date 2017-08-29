#!/bin/bash

for i in 1 2; do docker-machine create --driver digitalocean \
  --digitalocean-image  ubuntu-16-04-x64 \
  --digitalocean-access-token $FISHER_HALL_DOTOKEN \
  --digitalocean-private-networking \
  --digitalocean-size 512mb node-$i; done

docker-machine ssh node-1 docker swarm init --advertise-addr $(docker-machine ip node-1)

for i in 1 2 3; do \
  docker-machine ssh node-$i docker swarm join --token SWMTKN-1-3l8l43ag0sisurwpq8r37862r6mtsx9drelj75b6c0yw5dybo3-eebwijloeem96a1u2v79u5p6o 138.197.107.247:2377; done


docker-machine scp apps/basechurch/docker-compose.yml node-1:~
docker-machine scp apps/basechurch/.env.dev node-1:~

docker stack deploy --compose-file docker-compose.yml fisherhall
