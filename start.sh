#!/bin/sh

if [ "${RAILS_RNV}" = "development" ]
then
  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails db:seed:tag
fi