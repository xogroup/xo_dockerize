#!/usr/bin/env bash

# $1 = Environment (QA/Prod)
docker build -t sample_app:$1 -f scripts/docker/Dockerfile .
