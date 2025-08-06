require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load enums
require_relative '../app/enums/enums'

module DiscountingApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    config.autoload_lib(ignore: %w(assets tasks))

    # Only loads a smaller set of middleware suitable for API only apps.
    config.api_only = true

    # Set up minimal logging
    config.logger = Logger.new(STDOUT)
    config.log_level = :info

    # Ensure enums are loaded and available
    config.after_initialize do
      # Make enums easily accessible
      Object.const_set(:Enums, DiscountingApp::Enums)
    end
  end
end
