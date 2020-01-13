module Coral
  module Controller
    class Base
      protected getter context : HTTP::Server::Context

      def initialize(@context : HTTP::Server::Context)
      end
    end
  end
end
