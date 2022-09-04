class Reservation < ApplicationRecord
  belongs_to :room

  validates :day_start, presence: { message: "チェックインが未入力です" }
  validates :day_end, presence: { message: "チェックアウトが未入力です" }
  validates :number, presence: { message: "人数が未入力です" }
  validates :room_id, presence: { message: "不正な値を検知しました。恐れ入りますが、一度ホームに戻ってから予約内容をご確認下さい" }
  validates :user_id, uniqueness: {
    scope: [:room_id, :day_end, :day_start],
    message: "予約はすでに受付されております。ご登録済みの予約内容からご確認ください。"
  } 

  validate :number_check
  validate :date_check


  private

  def number_check
    errors.add(:number, "人数の入力値に誤りがあります") if number&. <= 0
  end

  def date_check
    errors.add(:day_end, "チェックアウト日を見直してください") if !day_end&.after? day_start if day_start && day_end
    errors.add(:day_start, "チェックイン日を見直してください") if !day_start&.after? Date.today if day_start && day_end
  end

end
