# frozen_string_literal: true

require "socket"

module CypressRails
  class Server
    extend Forwardable

    attr_reader :host, :port, :command, :log_path

    def initialize(host, command, log_path)
      @host = host
      @port = find_free_port
      @command = command
      @log_path = log_path
    end

    def start
      spawn_server
      until server_responsive?
        sleep 0.1
      end
      yield(host, port) if block_given?
    ensure
      stop_server
    end

    private

    attr_reader :pid

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
      Process.kill("SIGINT", pid) if pid
    end

    def build_command
      "#{command} --port #{port}"
    end

    def find_free_port
      server = ::TCPServer.new(host, 0)
      server.addr[1]
    ensure
      server.close if server
    end
  end
end
