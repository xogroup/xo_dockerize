#!/usr/bin/env bash

raw_environment_name=$1
raw_environment_type=$2
AWS_ACCESS_KEY_ID=`aws configure get aws_access_key_id`
AWS_SECRET_ACCESS_KEY=`aws configure get aws_secret_access_key`
AWS_REGION=`aws configure get region`

function qualified_environment_name {
  echo $raw_environment_name-$(app_name)-$(app_version)-$raw_environment_type | sed 's/_/-/g' | sed 's/\./-/g'
}

function app_version {
  cat ./VERSION
}

function app_name {
  cat ./APP_NAME
}

function is_existing_environment {
  errors=$(eb use $(qualified_environment_name) | grep "ERROR: Environment")
  if [$errors == ""]; then return 0; else return 1; fi
}

function qualified_instance_type {
  if [ $raw_environment_name == 'prod' ]; then echo 't2.medium'; else echo 't2.micro'; fi
}

#Copy the appropriate Dockerrun file to the root
cp ./scripts/docker/$raw_environment_name-Dockerrun.aws.json ./Dockerrun.aws.json
git add Dockerrun.aws.json

#Try to use the current eb environment
#If it exists deploy to existing environment
#If not then create a new one (blue/green deployment)
if is_existing_environment; then
  echo "Deploy"
  eb deploy $(qualified_environment_name) --timeout 30 --staged
else
  echo "Create"
  eb create $(qualified_environment_name) \
    -c $(qualified_environment_name)
    -t web \
    -i $(qualified_instance_type) \
    --tags Name=$(app_name),Team='Your Team Here',Application='$(app_name)',Environment=$(qualified_environment_name),Role='Web' \
    --envvars AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY,AWS_REGION=$AWS_REGION \
    --vpc.id 'vpc-12344' \
    --vpc.dbsubnets 'subnet-12345' \
    --vpc.ec2subnets 'subnet-12345 \
    --vpc.elbpublic \
    --vpc.publicip \
    --vpc.securitygroups 'sg-1235' \
    -k 'ec2-key-here' \
    -ip 'some_instance_profile' \
    --timeout 15
fi
