require "./src/coral"
require "./app/controllers/application_controller"
require "./app/controllers/*"
require "./config/routes"

Coral::Server.run
