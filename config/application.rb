require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShareRecipe
  class Application < Rails::Application
    config.load_defaults 6.0

    # タイムゾーン表示
    config.time_zone = 'Tokyo'

    # DB保存時間を東京に設定
    config.active_record.default_timezone = :local

    # i18n
    config.i18n.default_locale = :ja

    # Zeitwerk $LOAD_PATHにPathを追加しない(Zeitwerk有効時false推奨)
    config.add_autoload_paths_to_load_path = false

    # autoload path => ActiveSupport::Dependencies.autoload_paths
    config.autoload_paths += %W(#{config.root}/lib/validator)

    # config/locales/models/ja.ymlを起動時に自動読み込み
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # バリデーションエラー後にレイアウトが崩れるのを防ぐ
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      html_tag
    end

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false
    end

    # 認証トークンをremoteフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

  end
end
