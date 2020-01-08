require "radix"

module Router
  alias Action = HTTP::Server::Context, Hash(String, String) -> HTTP::Server::Context
  alias RouteContext = NamedTuple(action: Action, params: Hash(String, String))

  getter route_handler : RouteHandler = RouteHandler.new

  HTTP_METHODS = %w(get post put patch delete options)

  {% for http_method in HTTP_METHODS %}
    def {{http_method.id}}(path : String, &block : Action)
      @route_handler.add_route("/{{http_method.id.upcase}}" + path, block)
    end
  {% end %}

  class RouteHandler
    include HTTP::Handler

    def initialize
      @tree = Radix::Tree(Action).new
      @static_routes = {} of String => Action
    end

    def add_route(key : String, action : Action)
      if key.includes?(":") || key.includes?("*")
        @tree.add(key, action)
      else
        @static_routes[key] = action
        if key.ends_with? "/"
          @static_routes[key[0..-2]] = action
        else
          @static_routes[key + "/"] = action
        end
      end
    end

    def call(context : HTTP::Server::Context)
      if route_context = search_route(context)
        route_context[:action].call(context, route_context[:params])
      else
        call_next(context)
      end
    end

    def search_route(context : HTTP::Server::Context) : RouteContext?
      puts context.request.method + " " + context.request.path

      search_path = "/" + context.request.method + context.request.path
      action = @static_routes[search_path]?
      return {action: action, params: {} of String => String} if action

      route = @tree.find(search_path)
      return {action: route.payload, params: route.params} if route.found?

      nil
    end
  end
end
