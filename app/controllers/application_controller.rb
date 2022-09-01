class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_current_location, unless: :devise_controller?
  before_action :set_search


  def set_search
    @q = Room.ransack(params[:q]) 
    @rooms = @q.result(distinct: true)
  end


  # サインイン後に遷移するpathを設定
  def after_sign_in_path_for(resource)
    if session[:form_data].present?
       new_reservation_path
    else
      stored_location_for(resource) || root_path
    end
  end


  # ログアウト後に遷移するpathを設定
  def after_sign_out_path_for(resource)
    new_user_session_path 
  end


  # 入力フォームからアカウント名情報をDBに保存するために追加
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:introduction])
    devise_parameter_sanitizer.permit(:account_update, keys: [:image])
  end


  private

  def store_current_location
    store_location_for(:user, request.url)
  end


end
