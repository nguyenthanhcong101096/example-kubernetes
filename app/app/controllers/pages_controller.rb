class PagesController < ApplicationController
  def index
    user = User.all.sample

    render json: {
      app_name: ENV["APP"],
      view_count: Count.last&.view_count,
      user: user.slice(:name, :address)
    }
  end
end
