# frozen_string_literal: true

require "rails/railtie"
require "cypress_rails/middleware"

module CypressRails
  class Railtie < Rails::Railtie
    initializer :setup_cypress do |app|
      app.middleware.use Middleware
    end
  end
end
