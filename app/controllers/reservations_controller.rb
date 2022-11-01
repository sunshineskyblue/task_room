class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.includes(:room).where(user_id:current_user.id).order(day_start: "ASC")
  end

  def create
    @reservation = Reservation.new(reservation_params)
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
    reservation = Reservation.find(params[:id])
    reservation.destroy
    flash[:notice] = "予約情報を削除しました"
    redirect_to reservations_path
  end

  def new
    @reservation = Reservation.new(reservation_params_from_room)

    if user_signed_in?   #ログイン中の場合
      if current_user.name.blank? || current_user.introduction.blank?  #プロフィールが未登録の場合
        # ログイン後、new_reservationへのリダイレクトをさらにroom_path へのリダイレクトにつなぐ
        if (params[:room_id].blank?) && (session[:form_data].present?)  
          redirect_to room_path(session[:form_data]["room_id"],
          day_start: session[:form_data]["day_start"], 
          day_end: session[:form_data]["day_end"], 
          number: session[:form_data]["number"]
          ) 
        else   #ログイン状態のプロフィール未登録ユーザーをprofile_new画面につなぐ
          form_params_recieve
          if @reservation.invalid?
            flash[:reservation] = @reservation.errors.full_messages
            redirect_to room_path(@room_id,
            :day_start => @dayStart, 
            :day_end => @dayEnd, 
            :number => @number
            ) and return
            end
          params_checked_after_variables
          session_start
          redirect_to users_profile_path  
        end  
      else   #ログイン状態のプロフィール登録済みユーザーを確定画面につなぐ
        # ブラウザバック、フォワードに対応。ブラウザで進むをした時のみsessionを活かし、フォームから入った場合は、paramsで更新。
        if (params[:room_id].blank?) && (session[:form_data].present?) 
          session_to_params
        else  # 通常通りにフォームから入った場合
          form_params_recieve
          if @reservation.invalid?
          flash[:reservation] = @reservation.errors.full_messages
          redirect_to room_path(@room_id,  # render template:"rooms/show", id:@room and return => renderの場合、エラーが表示されたままとなる
            :day_start => @dayStart, 
            :day_end => @dayEnd, 
            :number => @number
          ) and return
          end
          params_checked_after_variables
        end
      end      
    else  #未ログインの場合
      form_params_recieve
      if @reservation.invalid?
        flash[:reservation] = @reservation.errors.full_messages
        redirect_to room_path(@room_id,
        :day_start => @dayStart, 
        :day_end => @dayEnd, 
        :number => @number
        ) and return
        end
      params_checked_after_variables
      session_start
      redirect_to new_user_session_path    
    end  
  end  

  private

  def session_to_params
    @term = session[:form_data]["term"] 
    @total = session[:form_data]["total"] 
    @dayStart = session[:form_data]["day_start"]
    @dayEnd = session[:form_data]["day_end"]
    @number = session[:form_data]["number"]
    @payment = session[:form_data]["payment"] 
    @room_id = session[:form_data]["room_id"]
    return @dayStart, @dayEnd, @number, @room_id, @payment, @term, @total
  end

  def  params_checked_after_variables
    if @dayStart && @dayEnd
    @term = (@dayEnd - @dayStart).to_i 
    @total = (params[:payment]).to_i * (params[:number]).to_i * (@dayEnd - @dayStart).to_i 
    return @term, @total
    end
  end
  
  def  form_params_recieve
    @dayStart = params[:day_start].to_date 
    @dayEnd = params[:day_end].to_date 
    @number = params[:number].to_i 
    @room_id = params[:room_id]
    @payment = params[:payment]
    return @dayStart, @dayEnd, @number, @room_id, @payment
  end
    
  def session_start
    session[:form_data] = {}
    session[:form_data]["day_start"] = @dayStart
    session[:form_data]["day_end"] = @dayEnd 
    session[:form_data]["number"] = @number
    session[:form_data]["payment"] = @payment
    session[:form_data]["room_id"] = @room_id
    session[:form_data]["term"] = @term
    session[:form_data]["total"] = @total
  end

  def reservation_params
    params.require(:reservation).permit(:day_start, :day_end, :number, :payment, :user_id, :room_id)
  end

  def reservation_params_from_room
    params.permit(:day_start, :day_end, :number, :payment, :user_id, :room_id)
  end
end

