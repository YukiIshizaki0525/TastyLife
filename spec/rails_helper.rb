require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# shoulda-matchersの読み込み
require 'shoulda/matchers'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
  #sign_inヘルパーを利用できるようにする
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Devise::Test::IntegrationHelpers, type: :request

  #FactoryBotもinclude
  config.include FactoryBot::Syntax::Methods

  # supportディレクトリを利用
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  # ヘッドレスモードのChromeで実行する
  config.before(:each) do |example|
    if example.metadata[:type] == :system
      driven_by :selenium, using: :headless_chrome, screen_size: [768, 654]
      # driven_by :selenium, using: :headless_chrome, screen_size: [1680, 1050] #=> フルサイズ
    end
  end

end

# /spec/rails_helper.rb  
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