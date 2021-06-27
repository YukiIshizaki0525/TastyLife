require_relative 'boot'

require 'rails/all'
# require "rails"
# require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_view/railtie"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module ShareRecipe
  class Application < Rails::Application
    config.load_defaults 6.0
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    config.i18n.default_locale = :ja
    config.add_autoload_paths_to_load_path = false
    config.autoload_paths += %W(#{config.root}/lib/validator)
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      html_tag
    end
    config.generators do |g|
      g.test_framework :rspec,
                        view_specs: false,
                        helper_specs: false,
                        controller_specs: false,
                        routing_specs: false,
                        request_specs: false
    end
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
