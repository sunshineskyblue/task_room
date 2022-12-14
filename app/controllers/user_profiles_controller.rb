class UserProfilesController < ApplicationController
  def edit
    @user = User.find_by(id: current_user.id)

    if session[:profile].present?
      @user.name = session[:profile]["name"]
      @user.introduction = session[:profile]["introduction"]
      session.delete(:profile)
    end
  end

  def update
    @user = User.find_by(id: current_user.id)

    if @user.update(user_profile_params)
      flash[:message] = "プロフィール情報を更新しました"
      redirect_to profile_user_profile_path(current_user.id)
    else
      render 'user_profiles/edit'
    end
  end

  private

  def user_profile_params
    params.require(:user).permit(:name, :introduction, :image)
  end
end
