class ReservationsController < ApplicationController

  def new
    @reservation = Reservation.new

    if params[:day_start].blank? || params[:day_end].blank? || params[:number].blank?
      flash[:notice] = "未入力の箇所があります"
      redirect_to room_path(params[:room_id]) 
    else
      @dayStart = params[:day_start].to_date
      @dayEnd = params[:day_end].to_date 
      @number = params[:number].to_i

      if @number <= 0
        flash[:notice] = "人数の入力値に誤りがあります"
        redirect_to room_path(params[:room_id]) 
      end

      
      if @dayEnd.after? @dayStart
        if @dayStart.after? Date.today
          @term = (@dayEnd - @dayStart).to_i 
          @total = (params[:payment]).to_i * (params[:number]).to_i * (@dayEnd - @dayStart).to_i
        else
          flash[:notice] = "日付設定を見直してください"
          redirect_to room_path(params[:room_id]) 
        end
      else
        flash[:notice] = "日付設定を見直してください"
        redirect_to room_path(params[:room_id]) 
      end
    end

  end


  def create

    @reservation = Reservation.new(room_params)
    @reservation.user_id = current_user.id 

    # binding.pry
    if @reservation.save
    # binding.pry
      flash[:notice] = "予約を完了しました"
      redirect_to root_path
    else
    # binding.pry
      flash[:error_notice] = "予約ができませんでした"
      render 'new'
    end
  end


  def index
    @reservations = Reservation.where(user_id:current_user.id)
  end

  private

  def room_params
    params.require(:reservation).permit(:day_start, :day_end, :number, :payment, :user_id, :room_id)
  end

end
