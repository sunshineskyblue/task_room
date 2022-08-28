class Reservation < ApplicationRecord
  belongs_to :room

  validates :day_start, presence: { message: "開始日が未入力です" }
  validates :day_end, presence: { message: "終了日が未入力です" }
  validates :number, presence: { message: "終了日が未入力です" }

  validate :number_check
  validate :date_check


  private

  def number_check
    errors.add(:number, "人数の入力値に誤りがあります") if number&. <= 0
  end

  def date_check
    errors.add(:day_end, "日付を見直してください") if !day_end&.after? day_start
    errors.add(:day_start, "日付を見直してください") if !day_start&.after? Date.today
  end

end
