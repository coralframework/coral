require "radix"
require "./route"

module Router
  alias RouteContext = NamedTuple(route: Route, params: Hash(String, String))

  class RouteHandler
    # This class maintains all the routes

    include HTTP::Handler

    HTTP_METHODS = %w(get post put patch delete options head trace connect)

    macro route(verb, path, controller, action)
      %handler = ->(context : HTTP::Server::Context) {
        controller = {{controller.id}}.new(context)
        controller.{{action.id}}
      }
      %verb = {{verb.upcase.id.stringify}}
      add_route(%verb, {{path}}, Router::Route.new(%handler))
    end

    {% for verb in HTTP_METHODS %}
      macro {{verb.id}}(*args)
        route {{verb}}, \{{*args}}
        {% if verb == :get %}
          route :head, \{{*args}}
        {% end %}
        {% if ![:trace, :connect, :options, :head].includes? verb %}
          route :options, \{{*args}}
        {% end %}
      end
    {% end %}



    def initialize
      @tree = Radix::Tree(Route).new
      @static_routes = {} of String => Route
    end

    def add_route(verb : String, path : String, route : Route)
      key = verb + path

      # Dynamic routes will be added to the tree
      if key.includes?(":") || key.includes?("*")
        @tree.add(key, route)

      # Static routes we can lookup faster in a hash
      else
        @static_routes[key] = route
        if key.ends_with? "/"
          @static_routes[key[0..-1]] = route
        else
          @static_routes[key + "/"] = route
        end
      end
    end

    def call(context : HTTP::Server::Context)
      if route_context = search_route(context)
        route_context[:route].call(context, route_context[:params])
      else
        call_next(context)
      end
    end

    def search_route(context : HTTP::Server::Context) : RouteContext?
      # Search static routes first
      search_path = context.request.method + context.request.path

      route = @static_routes[search_path]?
      return {route: route, params: {} of String => String} if route

      # Search dynamic routes
      route = @tree.find(search_path)
      return {route: route.payload, params: route.params} if route.found?

      nil
    end
  end
end
