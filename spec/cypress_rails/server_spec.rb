# frozen_string_literal: true

require "spec_helper"
require "open-uri"
require "cypress_rails/server"

RSpec.describe CypressRails::Server do
  let(:host) { "localhost" }
  let(:command) { "rackup spec/support/dummy_passing/config.ru" }
  let(:log_path) { "/dev/null" }
  let(:server) { described_class.new(host, command, nil, log_path) }

  describe "#port" do
    subject(:port) { server.port }

    it { is_expected.to be_open_port }
  end

  describe "#start" do
    it "starts the server and blocks until it is ready" do
      response = nil
      server.start {
        response = open("http://localhost:#{server.port}")
      }
      expect(response.status).to include "200"
    end

    context "when a healthcheck url is passed" do
      let(:command) { "rackup spec/support/dummy_healthcheck/config.ru" }
      let(:server) { described_class.new(host, command, "http://localhost/foobar", log_path) }

      it "pings the provided url" do
        response = nil
        server.start {
          response = open("http://localhost:#{server.port}/foobar")
        }
        expect(response.status).to include "200"
      end
    end

    it "yields the port number and host into the block" do
      expect { |b| server.start(&b) }.to yield_with_args("localhost", server.port)
    end
  end
end
