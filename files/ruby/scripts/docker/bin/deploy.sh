#!/usr/bin/env bash

#Set up the variables needed
VERSION=`cat ./VERSION`
APP_NAME=`cat ./APP_NAME`
APP_ENV=$1 #Environment (qa/prod)
TYPE=$2 #Type (web/worker)
APP_ENV_FULL=`if [ $APP_ENV = prod ]; then echo production; else echo $APP_ENV; fi`
AWS_KEY=`aws configure get aws_access_key_id`
AWS_SECRET=`aws configure get aws_secret_access_key`
AWS_REGION=`aws configure get region`
SECRET_KEY_BASE=`ruby ./scripts/setup/generate_secret_key.rb`

#Copy the appropriate Dockerrun file to the root
cp ./scripts/docker/$APP_ENV-Dockerrun.aws.json ./Dockerrun.aws.json
git add Dockerrun.aws.json

#Try to use the current eb environment
#If it exists deploy to existing environment
#If not then create a new one (blue/green deployment)
errors=`eb use $APP_ENV-$APP_NAME-$VERSION-$TYPE | grep "ERROR: Environment"`
if [$errors == ""]; then
  eb deploy $APP_ENV-$APP_NAME-$VERSION-$TYPE --timeout 30 --staged
else
  eb create $APP_ENV-$APP_NAME-$VERSION-$TYPE --cfg $APP_NAME-$APP_ENV -c $APP_ENV-$APP_NAME-$VERSION-$TYPE --timeout 15 --envvars AWS_ACCESS_KEY_ID=$AWS_KEY,AWS_SECRET_ACCESS_KEY=$AWS_SECRET,AWS_REGION=$AWS_REGION,SECRET_KEY_BASE=$SECRET_KEY_BASE,WEB_TYPE=$TYPE,RAILS_ENV=$APP_ENV_FULL,RAKE_ENV=$APP_ENV_FULL,WEB_CONCURRENCY=3
fi
