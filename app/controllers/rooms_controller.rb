class RoomsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def index
    @rooms = current_user.rooms.with_attached_room_image
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      price = Price.new(room_id: @room.id, value: @room.fee)
      price.switch_price_range
      price.save!

      flash[:message] = "ルーム情報を追加しました"
      redirect_to room_path(@room.id)
    else
      render 'rooms/new'
    end
  end

  def show
    @room = Room.find_by(id: params[:id])

    if @room.rates.present?
      @num_awards = @room.count_awards
      @num_scores = @room.rates.size
      @avg_scores = @room.calculate_avg
      @avg_cleanliness = @room.calculate_cleanliness_avg
      @avg_information = @room.calculate_information_avg
      @avg_communication = @room.calculate_communication_avg
      @avg_location = @room.calculate_location_avg
      @avg_price = @room.calculate_price_avg
      @avg_recommendation = @room.calculate_recommendation_avg
      @group_avg = @room.integrate_group_avgs
    end
  end

  def edit
    @room = Room.find_by(id: params[:id])
  end

  def update
    @room = Room.find_by(id: params[:id])

    if @room.update(room_params)
      flash[:message] = "物件情報を変更しました"
      redirect_to edit_room_path(@room.id)
    else
      render 'rooms/edit'
    end
  end

  private

  def room_params
    params.require(:room).permit(
      :name,
      :introduction,
      :fee,
      :adress,
      :user_id,
      :room_image,
      :number
    )
  end
end
