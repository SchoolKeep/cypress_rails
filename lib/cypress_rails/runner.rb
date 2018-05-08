# frozen_string_literal: true

module CypressRails
  class Runner
    def initialize(host:, port:, command: "npx cypress", output: IO.new(1))
      @host = host
      @port = port
      @command = command
      @output = output
    end

    def run
      pid = Process.spawn(
        {
          "CYPRESS_app_host" => host,
          "CYPRESS_app_port" => port.to_s,
        },
        command,
        out: output,
        err: [:child, :out]
      )
      output.close
      _, status = Process.wait2(pid)
      status.exitstatus
    end

    private

    attr_reader :host, :port, :command, :output
  end
end
