class User < ApplicationRecord 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :validatable
  
  attr_accessor :current_password
  has_one_attached :image
  has_many :rooms

  validates :name, presence: { message: "タイトルが未入力です" }, on: :update
  validates :introduction, presence: { message: "自己紹介が未入力です" }, on: :update
  

end
