require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Listed
  class Application < Rails::Application

    # Cross-Origin Resource Sharing (CORS) for Rack compatible web applications.
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :patch, :delete, :options], :expose => ['Access-Token', 'Client', 'UID']
      end
    end

  end
end
