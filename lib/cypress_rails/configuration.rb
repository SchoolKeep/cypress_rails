module CypressRails
  class Configuration
    attr_accessor :before_each, :scripts_path

    def initialize
      @before_each = -> {}
      @scripts_path = "spec/cypress/seeds"
    end
  end
end
