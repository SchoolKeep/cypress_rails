# frozen_string_literal: true

module CypressRails
  class Runner
    def initialize(host:, port:, output: IO.new(1))
      @host = host
      @port = port
      @output = output
    end

    def run
      pid = Process.spawn(
        {
          "CYPRESS_app_host" => host,
          "CYPRESS_app_port" => port.to_s,
        },
        "cd spec/support/dummy && npx cypress run && cd -",
        out: output,
        err: [:child, :out]
      )
      output.close
      Process.wait(pid)
    end

    private

    attr_reader :host, :port, :output
  end
end
