#!/usr/bin/env bash

docker rmi $(docker images -q --filter "dangling=true") 2> /dev/null

exit 0