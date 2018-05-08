# frozen_string_literal: true

require "spec_helper"
require "open-uri"
require "cypress_rails/server"

RSpec.describe CypressRails::Server do
  let(:host) { "localhost" }
  let(:command) { "rackup spec/support/dummy/config.ru" }
  let(:log_path) { "/dev/null" }

  describe "#port" do
    subject(:port) { described_class.new(host, command, log_path).port }

    it { is_expected.to be_open_port }
  end

  describe "#start" do
    subject(:server) { described_class.new(host, command, log_path) }

    it "starts the server and blocks until it is ready" do
      response = nil
      server.start {
        response = open("http://localhost:#{server.port}")
      }
      expect(response.status).to include "200"
    end

    it "yields the port number and host into the block" do
      expect { |b| server.start(&b) }.to yield_with_args("localhost", server.port)
    end
  end
end
