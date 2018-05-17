# frozen_string_literal: true

module CypressRails
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if cypress_rails_url?(request.path)
        setup! if setup_url?(request.path)
        seed!(request) if seed_url?(request.path)
        return [
          201,
          { "Content-Type" => "text/html" },
          [""]
        ]
      end

      @app.call(env)
    end

    private

    def cypress_rails_url?(path)
      path.starts_with?("/__cypress_rails__")
    end

    def setup_url?(path)
      path.gsub("/__cypress_rails__/", "") == "setup"
    end

    def seed_url?(path)
      path.gsub("/__cypress_rails__/", "") == "seeds"
    end

    def setup!
      reset_db!
    end

    def seed!(request)
      body = JSON.parse(request.body.read)
      CypressRails.seeds(body.fetch("seed")).call
    end

    def reset_db!
      CypressRails.configuration.before_each.call
    end
  end
end
