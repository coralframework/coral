module Coral
  module Controller
    class Base
      protected getter context : HTTP::Server::Context

      def initialize(@context : HTTP::Server::Context)
      end

      macro render(template)
        content = ECR.render {{template}}

        context.response.print content
        context
      end
    end
  end
end
