# frozen_string_literal: true

require "socket"

module CypressRails
  class Server
    extend Forwardable

    attr_reader :host, :port

    def initialize(host)
      @host = host
      @port = find_free_port
    end

    def start
      spawn_server
      until server_responsive?
        sleep 0.1
      end
      yield if block_given?
      stop_server
    end

    private

    attr_reader :pid

    def_delegators :configuration,
      :server_command,
      :log_path

    def spawn_server
      @pid = Process.spawn(
        build_command,
        out: [
          log_path,
          File::WRONLY | File::CREAT | File::TRUNC,
          0o600
        ],
        err: [:child, :out]
      )
      Process.detach(pid)
    end

    def server_responsive?
      system("curl #{host}:#{port}", [:out, :err] => "/dev/null")
    end

    def stop_server
      Process.kill("SIGINT", pid)
    end

    def build_command
      command = [server_command]
      command << "--port #{port}"
      command.join(" ")
    end

    def find_free_port
      server = ::TCPServer.new(host, 0)
      server.addr[1]
    ensure
      server.close if server
    end

    def configuration
      CypressRails.configuration
    end
  end
end
