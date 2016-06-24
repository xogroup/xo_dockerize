FROM ruby:2.3.1

USER root

COPY Gemfile* /tmp/
WORKDIR /tmp

RUN gem install bundler
RUN bundle install

ENV  APP_DIR /webapp/current

RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR
ADD . $APP_DIR

EXPOSE 80
RUN chmod +x scripts/start.sh

CMD scripts/start.sh
