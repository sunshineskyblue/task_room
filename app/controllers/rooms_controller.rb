class RoomsController < ApplicationController

  def index
    @rooms = Room.where(user_id:current_user.id)
  end

  def posts
    @rooms = Room.where(user_id:current_user.id)
  end
  
  def new
    @user = User.find_by(params[:id])
    @room = Room.new
  end
  
  def create

    @user = User.find_by(params[:id])
    @room = Room.new(params.require(:room).permit(:room_name, :room_intro, :fee, :adress, :user_id, :room_image))

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

    if @room.update(params.require(:room).permit(:room_name, :room_intro, :fee, :adress, :user_id, :room_image))
       flash[:notice] = "ルーム情報を更新しました"
       redirect_to :rooms
    else
      flash[:error_notice] = "ルーム情報を更新できませんでした"
      render 'edit'
    end
  end
  
  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    flash[:notice] = "ルーム情報を削除しました"
    redirect_to :rooms
  end


  def search
    
    @q = Room.ransack({combinator: 'and', groupings: search_params })
    @rooms = @q.result(distinct: true).all.order(updated_at: 'ASC')

    @rooms_count = @rooms.count

  end


  def area_search
    
    @q = Room.ransack({combinator: 'or', groupings: search_params })
    @rooms = @q.result(distinct: true).all.order(updated_at: 'ASC')

    @rooms_count = @rooms.count

  end


  private

  def search_params

    params.require(:q).permit(:room_name_or_room_intro_cont,:adress_cont)

    keywords = params[:q][:room_name_or_room_intro_cont]&.split(/[\p{blank}\s]+/)
    grouping_hash_keywords = keywords&.reduce({}){|hash, word| hash.merge(word => {room_name_or_room_intro_cont: word})}

    adresses = params[:q][:adress_cont]&.split(/[\p{blank}\s]+/)
    grouping_hash_adress = adresses&.reduce({}){|hash, word| hash.merge(word => {adress_cont: word})}

    grouping_hash = grouping_hash_keywords&.merge(grouping_hash_adress)

  end
  
end
