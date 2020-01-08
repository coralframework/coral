require "http/server"
require "./router"
require "./ext/*"

class Coral
  include Router

  getter port : Int32
  getter routes

  def self.run
    new.run
  end

  def initialize
    @port = (ENV["PORT"]? || 3000).to_i
    draw_routes
  end

  def run
    server = HTTP::Server.new([
      HTTP::ErrorHandler.new,
      HTTP::LogHandler.new,
      HTTP::CompressHandler.new,
      HTTP::StaticFileHandler.new("public", true, false),
      @route_handler,
    ])

    address = server.bind_tcp port
    puts "Listening on http://#{address}"
    server.listen
  end
end
