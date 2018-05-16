# frozen_string_literal: true

require "thor"
require "cypress_rails/runner"
require "cypress_rails/server"

module CypressRails
  Config = Struct.new(:command, :cypress_bin_path, :host, :log_path, :tests_path)

  class CLI < Thor
    class_option :command,
      type: :string,
      desc: "command to start the server",
      default: "bundle exec rails server",
      aliases: %w(-c)
    class_option :cypress_bin_path,
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
    class_option :tests_path,
      type: :string,
      desc: "path to Cypress tests",
      default: "./spec",
      aliases: %w(-t)

    desc "test", "Run all tests in headless mode"
    def test
      server.start do |host, port|
        exit Runner.new(
          host: host, port: port, bin_path: config.cypress_bin_path, tests_path: config.tests_path
        ).run
      end
    end

    desc "open", "Start the server and open Cypress Dashboard"
    def open
      server.start do |host, port|
        exit Runner.new(
          host: host, port: port, bin_path: config.cypress_bin_path, tests_path: config.tests_path
        ).open
      end
    end

    private

    def server
      @server ||= Server.new(config.host, config.command, config.log_path)
    end

    def config
      @config ||= Config.new(
        *options.values_at(:command, :cypress_bin_path, :host, :log_path, :tests_path)
      )
    end
  end
end
