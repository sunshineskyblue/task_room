class Reservation < ApplicationRecord
  # belongs_to :user
  belongs_to :room

  validates :day_start, presence: { message: "開始日が未入力です" }
  validates :day_end, presence: { message: "終了日が未入力です" }

end
