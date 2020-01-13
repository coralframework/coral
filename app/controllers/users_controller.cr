class UsersController < ApplicationController
  getter user_id : String?

  def index
    render "app/views/users/index.html.ecr"
  end

  def show
    @user_id = context.params["id"]

    render "app/views/users/show.html.ecr"
  end

  def create
  end
end
