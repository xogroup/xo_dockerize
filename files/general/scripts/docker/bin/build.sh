#!/usr/bin/env bash

# $1 = Environment (QA/Prod)
docker build -t project_name:$1 -f scripts/docker/Dockerfile .
