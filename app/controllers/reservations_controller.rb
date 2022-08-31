class ReservationsController < ApplicationController

  def index
    @reservations = Reservation.where(user_id:current_user.id).order(day_start: "ASC")
  end

  def create
    @reservation = Reservation.new(room_params)
    @reservation.user_id = current_user.id 
    
    if @reservation.save
      flash[:notice] = "予約を完了しました"
      session.delete("form_data")
      redirect_to reservation_path(@reservation.id)
    else
      flash[:error_notice] = "予約ができませんでした"
      render 'new'
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    flash[:notice] = "ルーム情報を削除しました"
    redirect_to reservations_path
  end

  def new
    if current_user.nil?
      @dayStart = params[:day_start].to_date
      @dayEnd = params[:day_end].to_date 
      @number = params[:number].to_i

      if @number <= 0
        flash[:notice] = "人数の入力値に誤りがあります"
        redirect_to room_path(params[:room_id]) 
      end

      if @dayStart.blank? || @dayEnd.blank? || @number.blank? 
        flash[:notice] = "未入力の箇所があります"
        redirect_to room_path(params[:room_id]) 
      end
      
      if (@dayStart.after? Date.today) && (@dayEnd.after? @dayStart)
        @term = (@dayEnd - @dayStart).to_i 
        @total = (params[:payment]).to_i * (params[:number]).to_i * (@dayEnd - @dayStart).to_i
        
        session[:form_data] = {}
        session[:form_data]["day_start"] = params[:day_start]
        session[:form_data]["day_end"] = params[:day_end]
        session[:form_data]["number"] = params[:number]
        session[:form_data]["payment"] = params[:payment]
        session[:form_data]["room_id"] = params[:room_id]
        session[:form_data]["term"] = @term
        session[:form_data]["total"] = @total

        redirect_to new_user_session_path    
      else
        flash[:notice] = "日付を見直してください"
        redirect_to room_path(params[:room_id]) 
      end

    else
      @reservation = Reservation.new

      # "params[:room_id].blank" の条件分岐によって、sessionを削除せずとも、
      #  paramsが代入されていない時のみにsession情報を反映させ、
      #  言い換えると、paramsが代入されている時は、paramsを優先させることができる。
      # sessionを残すことで、ブラウザのバックとフォワードに対応することができた
      # session自体は、現状createアクション時に削除する実装としているが、弊害はとりわけ見当たらない

      if params[:room_id].blank?   
        if session[:form_data].present?
          @term = session[:form_data]["term"] 
          @total = session[:form_data]["total"] 
          @dayStart = session[:form_data]["day_start"]
          @dayEnd = session[:form_data]["day_end"]
          @number = session[:form_data]["number"].to_i
          @payment = session[:form_data]["payment"] 
          @room_id = session[:form_data]["room_id"]
        end
      else
        @room_id = params[:room_id] 
        @payment = params[:payment]
        @dayStart = params[:day_start].to_date
        @dayEnd = params[:day_end].to_date 
        @number = params[:number].to_i

        if @dayStart.blank? || @dayEnd.blank? || @number.blank?
          flash[:notice] = "未入力の箇所があります"
          redirect_to room_path(@room_id)
        end

        if @number <= 0
          flash[:notice] = "人数の入力値に誤りがあります"
          redirect_to room_path(@room_id) 
        end
        
        if (@dayStart.after? Date.today) && (@dayEnd.after? @dayStart)
          @term = (@dayEnd - @dayStart).to_i 
          @total = (params[:payment]).to_i * (params[:number]).to_i * (@dayEnd - @dayStart).to_i
        else
          flash[:notice] = "日付を見直してください"
          redirect_to room_path(@room_id) 
        end
      end

    end

  end
  

  private

  def room_params
    params.require(:reservation).permit(:day_start, :day_end, :number, :payment, :user_id, :room_id)
  end

end






