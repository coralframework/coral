module Router
  class Route
    # This class is used to organize the Routing tree
    # The handler is a Proc that instantiates the controller and calls the proper action

    property :handler

    def initialize(@handler : HTTP::Server::Context ->)
    end

    # Simply forward the request along to the handler Proc
    def call(context, params)
      context.params = params
      handler.call(context)
    end
  end
end
