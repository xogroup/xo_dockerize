#!/usr/bin/env bash

# $1 = Environment (QA/Prod)

eval `aws ecr get-login --region us-east-1`
docker tag -f sample_app:$1 ECR_HOST/sample_app:$1
docker push ECR_HOST/sample_app:$1
