require "./coral"

class Application < Coral
  def draw_routes
    get "/" do |context, params|
      context.response.print "hey"
      context
    end

    get "/users/:id" do |context, params|
      context.response.print params["id"]
      context
    end
  end
end

Application.run
