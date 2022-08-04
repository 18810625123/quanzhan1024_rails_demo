require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
module RailsDemo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Beijing"
    # config.eager_load_paths << Rails.root.join("extras")

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*' # 可以接受字符串数组或者是正则表达式
        resource '*', :headers => :any, :methods => [:get, :post, :options], :credentials => false
      end
    end

    config.api_only = true

    # Add app/api to paths, autoload paths
    # config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'my', '*')]
  end
end
