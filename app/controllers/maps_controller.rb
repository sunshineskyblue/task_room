class MapsController < ApplicationController
  def show
    @room = Room.find(params[:id])
  end
end
