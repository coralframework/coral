require "http/server"
require "./router"
require "./ext/*"
require "./controller/*"

module Coral
  class Server
    include Router

    getter route_handler : RouteHandler = RouteHandler.new
    getter port : Int32

    def self.instance
      @@instance ||= new
    end

    def self.run
      instance.run
    end

    def initialize
      @port = (ENV["PORT"]? || 3000).to_i
    end

    def run
      server = HTTP::Server.new([
        HTTP::ErrorHandler.new,
        HTTP::LogHandler.new,
        HTTP::CompressHandler.new,
        HTTP::StaticFileHandler.new("public", true, false),
        route_handler,
      ])

      address = server.bind_tcp port
      puts "Listening on http://#{address}"
      server.listen
    end

    def self.configure
      with self yield instance
    end

    def self.draw_routes
      with instance.route_handler yield
    end
  end
end
