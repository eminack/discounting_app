require 'bundler/setup'
Bundler.require(:default)

module DiscountingApp
  class Application
    class << self
      attr_accessor :env, :root

      def initialize!
        # Set application root
        self.root = File.expand_path('../..', __dir__)

        # Set environment
        self.env = ENV['APP_ENV'] || 'development'

        # Add lib directory to load path
        $LOAD_PATH.unshift(root)

        # Load all configuration files
        load_config

        # Load all initializers
        load_initializers

        # Load all application files in proper order
        load_application_files

        self
      end

      private

      def load_config
        # Load configuration files from config directory
        Dir[File.join(root, 'lib/config/*.rb')].each do |file|
          next if file.end_with?('application.rb') # Skip application.rb itself

          require file
        end
      end

      def load_initializers
        # Load all initializer files
        Dir[File.join(root, 'lib/config/initializers/*.rb')].sort.each do |file|
          require file
        end
      end

      def load_application_files
        # Load files in specific order to handle dependencies

        # First load models as they are the base entities
        Dir[File.join(root, 'lib/models/**/*.rb')].sort.each do |file|
          require file
        end

        # Then load repositories as they depend on models
        Dir[File.join(root, 'lib/repositories/**/*.rb')].sort.each do |file|
          require file
        end

        # Load services after repositories as they might use them
        Dir[File.join(root, 'lib/services/**/*.rb')].sort.each do |file|
          require file
        end

        # Load helpers that might be used in controllers
        Dir[File.join(root, 'lib/helpers/**/*.rb')].sort.each do |file|
          require file
        end

        # Finally load controllers as they might depend on all above
        Dir[File.join(root, 'lib/controllers/**/*.rb')].sort.each do |file|
          require file
        end
      end
    end
  end
end
