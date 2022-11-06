class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.includes(:room)
      .where(user_id: current_user.id)
      .order(checkin: "ASC")
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
    # ログイン or プロフィール登録完了後のリダイレクト時
    # params[:room_id]の確認できれば、params優先。（ブラウザバック後、フォームより値更新時）
    if params[:room_id].blank? && session[:form_data].present?
      # ログイン後、プロフィール未登録の場合は、紹介画面に再度リダイレクト
      if current_user.name.blank? || current_user.introduction.blank?
        redirect_to room_path(session[:form_data]["room_id"],
          checkin: session[:form_data]["checkin"],
          checkout: session[:form_data]["checkout"],
          number: session[:form_data]["number"])
        # sessionを削除しないと無限ループ
        session.delete("form_data") && return
      end
      # validateをしない
      @reservation = Reservation.new(session[:form_data])
      set_stay_length
      set_total_payment && return
    end

    @reservation = Reservation.new(reservation_params_from_room)

    # validationチェック
    if @reservation.invalid?
      flash[:reservation] = @reservation.errors.full_messages
      redirect_to(room_path(@reservation.room_id,
        :checkin => @reservation.checkin,
        :checkout => @reservation.checkout,
        :number => @reservation.number)) && return
    end

    # 未ログインの場合  => ログイン画面につなぐ
    if !user_signed_in?
      set_stay_length
      set_total_payment
      session_start
      redirect_to(new_user_session_path) && return
    end

    # プロフィール未登録 => 登録画面につなぐ
    if current_user.name.blank? || current_user.introduction.blank?
      set_stay_length
      set_total_payment
      session_start
      redirect_to(users_profile_path) && return
    end
    set_stay_length
    set_total_payment
  end

  private

  def reservation_params
    params.require(:reservation).permit(:checkin, :checkout, :number, :payment, :user_id, :room_id)
  end

  def reservation_params_from_room
    params.permit(:checkin, :checkout, :number, :payment, :user_id, :room_id)
  end

  def set_stay_length
    @stay_length = (@reservation.checkout - @reservation.checkin).to_i
  end

  def set_total_payment
    @total_payment = @reservation.payment * @reservation.
      number * (@reservation.checkout - @reservation.checkin).to_i
  end

  def session_start
    session[:form_data] = {}
    session[:form_data]["checkin"] = @reservation.checkin
    session[:form_data]["checkout"] = @reservation.checkout
    session[:form_data]["number"] = @reservation.number
    session[:form_data]["payment"] = @reservation.payment
    session[:form_data]["room_id"] = @reservation.room_id
  end
end
