FROM ruby:2.6.5

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn

RUN mkdir /RecipeApp

WORKDIR /RecipeApp

ADD Gemfile /RecipeApp/Gemfile
ADD Gemfile.lock /RecipeApp/Gemfile.lock

RUN gem install bundler
RUN bundle install