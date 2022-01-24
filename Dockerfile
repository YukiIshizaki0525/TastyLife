FROM ruby:2.6.5

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn

RUN mkdir /RecipeApp

WORKDIR /RecipeApp

COPY Gemfile /RecipeApp/Gemfile
COPY Gemfile.lock /RecipeApp/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["sh", "/start.sh"]

RUN mkdir -p tmp/sockets
