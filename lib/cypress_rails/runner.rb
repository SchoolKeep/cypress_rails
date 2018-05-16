# frozen_string_literal: true

module CypressRails
  class Runner
    def initialize(host:, port:, bin_path: "npx cypress", tests_path:, output: IO.new(1))
      @host = host
      @port = port
      @bin_path = bin_path
      @tests_path = tests_path
      @output = output
    end

    def run
      pid = Process.spawn(
        {
          "CYPRESS_app_host" => host,
          "CYPRESS_app_port" => port.to_s,
        },
        [bin_path, "run", "-P #{tests_path}"].join(" "),
        out: output,
        err: [:child, :out]
      )
      output.close
      _, status = Process.wait2(pid)
      status.exitstatus
    end

    def open
      pid = Process.spawn(
        {
          "CYPRESS_app_host" => host,
          "CYPRESS_app_port" => port.to_s,
        },
        [bin_path, "open", "-P #{tests_path}"].join(" "),
        out: output,
        err: [:child, :out]
      )
      output.close
      Process.wait(pid)
    end

    private

    attr_reader :host, :port, :bin_path, :tests_path, :output
  end
end
