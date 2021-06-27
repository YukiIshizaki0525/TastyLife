require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

require 'shoulda/matchers'

  # supportディレクトリを利用
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Capybara.register_driver :remote_chrome do |app|
  url = "http://chrome:4444/wd/hub"
  caps = ::Selenium::WebDriver::Remote::Capabilities.chrome(
    "goog:chromeOptions" => {
      "args" => [
        "no-sandbox",
        "headless",
        "disable-gpu",
        "window-size=768, 654"
      ]
    }
  )
  Capybara::Selenium::Driver.new(app, browser: :remote, url: url, timeout: 600, desired_capabilities: caps)
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
  #sign_inヘルパーを利用できるようにする
  config.include Devise::Test::IntegrationHelpers, type: :system

  #FactoryBotもinclude
  config.include FactoryBot::Syntax::Methods

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 3000
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # 今回はRspecを使うのでこのように設定
    with.test_framework :rspec

    # shoulda-matchersを使いたいテストライブラリを指定
    with.library :active_record
    with.library :active_model
    with.library :action_controller
    # Or, choose the following (which implies all of the above):
    with.library :rails
  end
end

# ファクトリで添付ファイルを扱えるようにする
FactoryBot::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end