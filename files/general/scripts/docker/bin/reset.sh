#!/usr/bin/env bash

docker rm -v -f $(docker ps -aq) 2> /dev/null
docker rmi -f $(docker images -aq) 2> /dev/null

exit 0