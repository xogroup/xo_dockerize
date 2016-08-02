# xo_dockerize
Adds the skeleton of files needed to get your project working with Docker and ElasticBeanstalk

The goal of this project is to enable any existing or new project to conform to a template of dockerizing and deploying to Elastic Beanstalk.

It adds the necessary files to your project so that you can just run

``` make release env=qa type=web ```

## Setup

Just run:

``` ./dockerize.rb this ```

Follow the prompts to fill in the information for your project:

```
⇒  ./dockerize.rb this
Copying setup files...

Please enter the information for your application:

Application Name:
JustNeph

ECR Host:
12341231.aws.com

Version:
1.0.0
```

## Test Run
To run this as a dry run into a test folder:

```./dockerize.rb this --test```

## Documentation

For further documentation on the dockerizing command just run:

``` ./dockerize.rb this --help ```

```
NAME:
    this

  SYNOPSIS:
    dockerize this [options]

  DESCRIPTION:
    Will initiate the dockerization process

  EXAMPLES:
    # description
    dockerize this --ruby --circleci

  OPTIONS:
    --ruby
        Adds the files for a ruby/rails project

    --circleci
        Adds the files for a circle ci supported project
```

This will copy all the files needed based on the answers to the questions

### Supports

* General Application Setup
* Ruby/Rails setup
* Circle CI
