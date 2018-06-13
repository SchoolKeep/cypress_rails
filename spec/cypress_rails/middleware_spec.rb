require "spec_helper"
require "rack"
require "json"
require "active_support/core_ext/string"
require "cypress_rails"

RSpec.describe CypressRails::Middleware do
  describe "sending params to scripts" do
    let(:app) {
      lambda { |env| [200, env, ["OK"]] }
    }
    let(:middleware) { described_class.new(app) }
    let(:request) { Rack::MockRequest.new(middleware) }

    it "calls script with params" do
      scripts = double(:scripts)

      allow(scripts).to receive(:call)
      allow(CypressRails).to receive(:scripts) { scripts }

      data = { name: "sending_params", params: { user_id: 1, flag: false } }
      request.post("/__cypress_rails__/scripts", input: data.to_json)

      expect(scripts).to have_received(:call).with({
        "user_id" => 1,
        "flag" => false
      })
    end
  end
end