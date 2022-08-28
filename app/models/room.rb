class Room < ApplicationRecord
  
  validates :room_name, presence: { message: "ルーム名が未入力です" }
  validates :room_intro, presence: { message: "ルーム紹介が未入力です" }
  validates :fee, presence: { message: "料金が未登録です" }
  validates :adress, presence: { message: "住所が未登録です" }

  validate :fee_check

  belongs_to :user
  has_many :reservations
  has_one_attached :room_image


  private

  def fee_check
    errors.add(:fee, "料金は1,000円以上で登録してください") if fee&. < 1000
    errors.add(:fee, "料金は1,000円単位で設定してください") if fee.to_i % 1000 != 0 
  end
  
end
