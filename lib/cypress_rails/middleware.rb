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
        execute_script!(request) if scripts_url?(request.path)
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

    def scripts_url?(path)
      path.gsub("/__cypress_rails__/", "") == "scripts"
    end

    def setup!
      reset_db!
    end

    def execute_script!(request)
      body = JSON.parse(request.body.read)
      script = CypressRails.scripts(body.fetch("name"))

      params = body.fetch("params", {})

      if params.any?
        script.call(params)
      else
        script.call
      end
    end

    def reset_db!
      CypressRails.configuration.before_each.call
    end
  end
end
