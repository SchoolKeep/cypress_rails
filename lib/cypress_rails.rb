# frozen_string_literal: true
#
require "cypress_rails/version"
require "cypress_rails/railtie"
require "cypress_rails/configuration"

module CypressRails
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end


  def scripts(name)
    path = Pathname.new(configuration.scripts_path).join("#{name}.rb")
    instance_eval File.read(
      path
    )
  end
  module_function :scripts
end
