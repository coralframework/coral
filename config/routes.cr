Coral::Server.draw_routes do
  get "/", MainController, :show

  get "/users", UsersController, :index
  get "/users/:id", UsersController, :show
  post "/users", MainController, :create
end
