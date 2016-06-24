#!/usr/bin/env bash

# $1 = Environment (QA/Prod)

eval `aws ecr get-login --region us-east-1`
docker tag -f project_name:$1 ECR_HOST/project_name:$1
docker push ECR_HOST/project_name:$1
