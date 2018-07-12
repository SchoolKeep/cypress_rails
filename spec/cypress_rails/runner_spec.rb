# frozen_string_literal: true

require "spec_helper"
require "cypress_rails/server"
require "cypress_rails/runner"

RSpec.describe CypressRails::Runner do
  let(:host) { "localhost" }
  let(:log_path) { "/dev/null" }
  let(:bin_path) { "cd #{project_path} && npx cypress" }
  let(:tests_path) { "." }
  let(:pipe) { IO.pipe }
  let(:w) { pipe[1] }
  let(:r) { pipe[0] }

  context "when tests are passing" do
    let(:project_path) { "spec/support/dummy_passing" }
    let(:server) { "rackup #{project_path}/config.ru" }

    it "runs cypress correctly" do
      CypressRails::Server.new(host, server, nil, log_path).start do |host, port|
        CypressRails::Runner.new(
          host: host,
          port: port,
          bin_path: bin_path,
          tests_path: tests_path,
          output: w
        ).run("electron")
      end
      result = r.read
      expect(result).to match(/Visiting the root address/)
      expect(result).to match(/renders OK/)
      expect(result).to match(/\(Tests Finished\)/)
      r.close
    end

    it "returns status code 0" do
      status = nil
      CypressRails::Server.new(host, server, nil, log_path).start do |host, port|
        status = CypressRails::Runner.new(
          host: host,
          port: port,
          bin_path: bin_path,
          tests_path: tests_path,
          output: w
        ).run("electron")
      end
      r.read
      r.close
      expect(status).to eq 0
    end
  end

  context "when tests are failing" do
    let(:project_path) { "spec/support/dummy_failing" }
    let(:server) { "rackup #{project_path}/config.ru" }

    it "runs cypress correctly" do
      CypressRails::Server.new(host, server, nil, log_path).start do |host, port|
        CypressRails::Runner.new(
          host: host,
          port: port,
          bin_path: bin_path,
          tests_path: tests_path,
          output: w
        ).run("electron")
      end
      result = r.read
      expect(result).to match(/Visiting the root address/)
      expect(result).to match(/renders OK/)
      expect(result).to match(/\(Tests Finished\)/)
      r.close
    end

    it "returns non-zero status code" do
      status = nil
      CypressRails::Server.new(host, server, nil, log_path).start do |host, port|
        status = CypressRails::Runner.new(
          host: host,
          port: port,
          bin_path: bin_path,
          tests_path: tests_path,
          output: w
        ).run("electron")
      end
      r.read
      r.close
      expect(status).not_to eq 0
    end
  end
end
