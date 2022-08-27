class Room < ApplicationRecord
  
  validates :room_name, presence: { message: "ルーム名が未入力です" }
  validates :room_intro, presence: { message: "ルーム紹介が未入力です" }
  validates :fee, presence: { message: "料金が未登録です" }
  validates :adress, presence: { message: "住所が未登録です" }

  belongs_to :user
  has_many :reservations
  has_one_attached :room_image
  
end
