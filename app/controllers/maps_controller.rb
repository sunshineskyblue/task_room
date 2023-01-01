class MapsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @room = Room.find(params[:id])
  end
end
