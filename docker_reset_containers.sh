#!/bin/bash

echo Stop all Docker containers
docker stop $(docker ps -aq)

echo Remove exited Docker containers
docker ps --filter status=dead --filter status=exited -aq | xargs -r docker rm -v

echo Remove unused Docker images
docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs -r docker rmi