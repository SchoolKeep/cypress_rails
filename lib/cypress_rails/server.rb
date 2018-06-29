# frozen_string_literal: true

require "socket"
require "uri"

module CypressRails
  class Server
    extend Forwardable

    attr_reader :host, :port, :command, :healthcheck_url, :log_path

    def initialize(host, command, healthcheck_url, log_path)
      @host = host
      @port = find_free_port
      @command = command
      @healthcheck_url = URI(healthcheck_url || "http://#{host}").tap { |uri| uri.port = port }
      @log_path = log_path
    end

    def start
      spawn_server
      until server_responsive?
        puts "Pinging #{healthcheck_url.to_s}..."
        sleep 1
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
      system("curl #{healthcheck_url}", [:out, :err] => "/dev/null")
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
