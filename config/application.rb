require_relative "boot"

require "rails"
require "active_job/railtie"  
require "rails/all"

Bundler.require(*Rails.groups)

module ApIapp
  class Application < Rails::Application
    config.load_defaults 8.0

    config.active_job.queue_adapter = :sidekiq

    config.autoload_lib(ignore: %w[assets tasks])
  end
end
