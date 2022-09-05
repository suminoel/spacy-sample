require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lucy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.autoloader = :classic

    config.action_controller.default_protect_from_forgery = true

    # productionでもrails consoleを使えるようにする
    config.web_console.development_only = false

    # devise languages ja
    config.i18n.default_locale = :ja

    # Time Zone Setting
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # Rack Attack
    config.middleware.use Rack::Attack

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # 主にdeviseを使うのに必要
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::Flash

    # クロスドメイン対策は入れておいたほうが良い
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '/api/v1/*',
          :headers => :any,
          :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          :methods => [:get, :post, :options, :delete, :put]
      end
    end
  end
end
