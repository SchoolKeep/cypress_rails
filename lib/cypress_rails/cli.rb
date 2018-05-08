# frozen_string_literal: true

require "thor"
require "cypress_rails/server"

module CypressRails
  Config = Struct.new(:command, :cypress_command, :host, :log_path, :test_path)

  class CLI < Thor
    class_option :command,
      required: true,
      type: :string,
      desc: "command to start the server",
      aliases: %w(-c)
    class_option :cypress_command,
      type: :string,
      desc: "command to run cypress",
      default: "npx cypress",
      aliases: %w(-cc)
    class_option :host,
      type: :string,
      desc: "host on which to start the local server",
      default: "localhost",
      aliases: %w(-h)
    class_option :log_path,
      type: :string,
      desc: "path to the log file for the server",
      default: "/dev/null",
      aliases: %w(-l)
    class_option :test_path,
      type: :string,
      desc: "path to Cypress tests",
      default: "./spec/cypress",
      aliases: %w(-t)

    desc "test", "Run all tests in headless mode"
    def test
      server.start do |host, port|
        system("curl http://#{host}:#{port}")
      end
    end

    desc "open", "Start the server and open Cypress Dashboard"
    def open
      puts options
    end

    private

    def server
      @server ||= Server.new(config.host, config.command, config.log_path)
    end

    def config
      @config ||= Config.new(
        *options.values_at(:command, :cypress_command, :host, :log_path, :test_path)
      )
    end
  end
end
