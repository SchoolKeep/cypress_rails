# frozen_string_literal: true

require "singleton"
require "cypress_rails/version"

module CypressRails
  def self.configure
    yield(configuration)
  end

  def self.configuration
    Configuration.instance
  end

  class Configuration
    include Singleton

    attr_accessor :server_command, :log_path

    def initialize
      @server_command = ""
      @log_path = "/dev/null"
    end
  end
end
