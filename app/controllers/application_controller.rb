class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search

  def set_search
    @q = Room.ransack(params[:q]) 
    @rooms = @q.result(distinct: true)
  end


  # このアクションを追加
  def after_sign_in_path_for(resource)
    root_path
  end

  # ログアウト後に遷移するpathを設定
  def after_sign_out_path_for(resource)
    new_user_session_path 
  end

  protected
  
  # 入力フォームからアカウント名情報をDBに保存するために追加
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:introduction])
    devise_parameter_sanitizer.permit(:account_update, keys: [:image])
  end


end
