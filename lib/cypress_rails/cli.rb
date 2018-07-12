# frozen_string_literal: true

require "thor"
require "cypress_rails/runner"
require "cypress_rails/server"

module CypressRails
  Config = Struct.new(
    :command, :cypress_bin_path, :host, :log_path, :tests_path, :healthcheck_url, :browser
  )

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
    class_option :healthcheck_url,
      type: :string,
      desc: <<~DESC,
        url to ping the server before running tests (you don't need the port, it will be injected)
      DESC
      aliases: %w(-u)
    class_option :browser,
      type: :string,
      desc: <<~DESC,
        which browser to use with test command, allowed values: chrome, electron
      DESC
      default: "chrome",
      aliases: %w(-b)

    desc "test", "Run all tests in headless mode"
    def test
      server.start do |host, port|
        exit Runner.new(
          host: host, port: port, bin_path: config.cypress_bin_path, tests_path: config.tests_path
        ).run(config.browser)
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
      @server ||= Server.new(config.host, config.command, config.healthcheck_url, config.log_path)
    end

    def config
      @config ||= Config.new(
        *options.values_at(
          :command, :cypress_bin_path, :host, :log_path, :tests_path, :healthcheck_url, :browser
        )
      )
    end
  end
end
