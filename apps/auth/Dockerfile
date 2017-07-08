FROM ruby:2.4.1

MAINTAINER Amos Chan <ac@amoschan.com>

RUN apt-get update -qq && apt-get install -y build-essential

ENV RACK_ENV production
ENV MAIN_APP_FILE main.rb
ENV APP_HOME /app

RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

CMD ["ruby", "main.rb"]
