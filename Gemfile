source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
gem 'mysql2', '>= 0.4.4'
gem 'puma', '~> 4.1'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false

# ログイン機能
gem 'devise'
# 日本語化
gem 'rails-i18n', '~> 6.0'
gem 'devise-i18n'
# Bootstrap
gem 'devise-bootstrap-views', '~> 1.0'

# ActiveStorageバリデーション用
gem 'active_storage_validations', '0.8.2'
# 画像処理用
gem 'image_processing',           '1.9.3'
gem 'mini_magick',                '4.9.5'

gem 'annotate'
gem 'kaminari'
gem 'ransack'

# 閲覧数カウント
gem 'impressionist'

gem 'font-awesome-sass'

# N+1問題
gem 'bullet'

gem 'mini_magick'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rails-flog', require: 'flog'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'spring-commands-rspec'
  gem 'faker'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rubocop'
  gem 'letter_opener_web'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'webdrivers'
  gem 'launchy'
  gem 'shoulda-matchers',
    git: 'https://github.com/thoughtbot/shoulda-matchers.git',
    branch: 'rails-5'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
