# frozen_string_literal: true

require "spec_helper"
require "cypress_rails/server"
require "cypress_rails/runner"

RSpec.describe CypressRails::Runner do
  let(:host) { "localhost" }
  let(:command) { "rackup spec/support/dummy/config.ru" }
  let(:log_path) { "/dev/null" }
  let(:pipe) { IO.pipe }
  let(:w) { pipe[1] }
  let(:r) { pipe[0] }

  it "runs cypress correctly" do
    CypressRails::Server.new(host, command, log_path).start do |host, port|
      CypressRails::Runner.new(host: host, port: port, output: w).run
    end
    result = r.read
    expect(result).to match(/Visiting the root address/)
    expect(result).to match(/renders OK/)
    expect(result).to match(/\(Tests Finished\)/)
    r.close
  end
end
