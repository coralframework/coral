class MainController < ApplicationController
  def show
    context.response.print "hey"
    context
  end

  def create
    context.response.print "post"
    context
  end
end
