class UsersController < ApplicationController
  def index
    context.response.print "Users"
    context
  end

  def show
    user_id = context.params["id"]
    context.response.print "User ##{user_id}"
    context
  end
end
