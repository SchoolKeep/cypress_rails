# frozen_string_literal: true
#
require "cypress_rails/version"
require "cypress_rails/railtie"
require "cypress_rails/configuration"

module CypressRails

  def seeds(name)
    instance_eval File.read("spec/cypress/seeds/#{name}.rb")
  end
  module_function :seeds
end
