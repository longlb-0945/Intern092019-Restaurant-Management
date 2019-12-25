require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Intern092019RestaurantManagement
  class Application < Rails::Application
    config.assets.paths << Rails.root.join("vendor", "assets")
    config.load_defaults 6.0
    config.active_job.queue_adapter = :sidekiq
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :en
    config.middleware.use I18n::JS::Middleware
    I18n::JS.export_i18n_js_dir_path = "app/javascript/packs"
  end
end
