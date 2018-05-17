module CypressRails
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :before_each

    def initialize
      @before_each = -> {}
    end
  end
end
