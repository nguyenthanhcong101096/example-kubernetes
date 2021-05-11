class PagesController < ApplicationController
  def index
    user = User.all.sample

    render json: {
      app_name: ENV["APP"],
      user: user.slice(:name, :address)
    }
  end
end
