FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
WORKDIR /code
COPY Gemfile Gemfile.lock source_files output ./
RUN bundle install
