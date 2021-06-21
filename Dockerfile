FROM ruby:2.6.5

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn

RUN mkdir /myproject

WORKDIR /myproject

ADD Gemfile /myproject/Gemfile

RUN bundle config --local set path 'vendor/bundle' \
  && bundle install

ADD . /myproject