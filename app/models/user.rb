class User < ApplicationRecord 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :validatable
  
  # attr_accessor :current_password

  has_one_attached :image
  has_many :rooms, dependent: :destroy

  # validates :name, presence: { message: "ユーザー名が未入力です" }, on: :update
  # validates :introduction, presence: { message: "自己紹介が未入力です" }, on: :update
  # validate :length_count, on: :update


  def update_without_current_password(params, *options)
    params.delete(:current_password)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end


  private

  def length_count
    errors.add(:name, "20文字以内で入力してください") if name&.length > 20
    errors.add(:name, "3文字以上で入力してください") if name&.length < 3
  end

  
end
