class RoomsController < ApplicationController
  def index
    @rooms = Room.where(user_id: current_user.id)
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      flash[:notice] = "ルーム情報を追加しました"
      redirect_to root_path
    else
      flash[:error_notice] = "ルーム情報を追加できませんでした"
      render 'new'
    end
  end

  def show
    @room = Room.find(params[:id])
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update(room_params)
      flash[:notice] = "ルーム情報を更新しました"
      redirect_to :rooms
    else
      flash[:error_notice] = "ルーム情報を更新できませんでした"
      render 'edit'
    end
  end

  def destroy
    room = Room.find(params[:id])
    room.destroy
    flash[:notice] = "ルーム情報を削除しました"
    redirect_to :rooms
  end

  def search
    search_form = RoomSearchForm.new(search_params)

    if search_form.valid?
      @search = search_form.link_adress_keywords
      @rooms = search_form.search_and_condition.order(updated_at: 'ASC')
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def area_search
    search_form = RoomSearchForm.new(search_params)
    @search_area = search_form.search_area
    @rooms = search_form.search_or_condition.order(updated_at: 'ASC')
  end

  private

  def search_params
    params.require(:q)
  end

  def room_params
    params.require(:room).permit(:room_name, :room_intro, :fee, :adress, :user_id, :room_image)
  end
end
