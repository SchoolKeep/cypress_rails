# frozen_string_literal: true

require "spec_helper"
require "open-uri"
require "cypress_rails"
require "cypress_rails/server"

RSpec.describe CypressRails::Server do
  describe "#port" do
    subject(:port) { described_class.new("localhost").port }

    it { is_expected.to be_open_port }
  end

  describe "#start" do
    subject(:server) { described_class.new("localhost") }

    it "starts the server and blocks until it is ready" do
      CypressRails.configure do |config|
        config.server_command = "rackup spec/support/dummy/config.ru"
      end

      response = nil
      server.start {
        response = open("http://localhost:#{server.port}")
      }
      expect(response.status).to include "200"
    end
  end
end
