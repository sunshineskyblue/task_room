class Reservation < ApplicationRecord
  belongs_to :room

  validates :checkin, presence: { message: "チェックインが未入力です" }
  validates :checkout, presence: { message: "チェックアウトが未入力です" }
  validates :number, presence: { message: "人数が未入力です" }
  validates :room_id, presence: { message: "不正な値を検知しました。恐れ入りますが、一度ホームに戻ってから予約内容をご確認下さい" }
  validates :user_id, uniqueness: {
    scope: [:room_id, :checkout, :checkin],
    message: "予約はすでに受付されております。ご登録済みの予約内容からご確認ください。",
  }

  validate :more_than_one_guest
  validate :check_date_consistency
  validate :check_empty

  scope :across_checkin, -> (room_id:, checkin:) { where("room_id = ?", room_id).where("checkin <= ? and checkout >= ? ", checkin, checkin) }
  scope :across_checkout, -> (room_id:, checkout:) { where(" room_id = ?", room_id).where("checkin < ? and checkout >= ?", checkout, checkout) }
  scope :between_checkin_checkout, -> (room_id:, checkin:, checkout:) { where(" room_id = ?", room_id).where("checkin >= ? and checkout <= ?", checkin, checkout) }

  private

  def more_than_one_guest
    errors.add(:number, "人数の入力値に誤りがあります") if number&. <= 0
  end

  def check_date_consistency
    errors.add(:checkout, "チェックアウト日を見直してください") if !checkout&.after? checkin
    errors.add(:checkin, "チェックイン日を見直してください") if !checkin&.after? Date.today
  end

  def check_empty
    across_checkin = Reservation.across_checkin(room_id: room_id, checkin: checkin)
    across_checkout = Reservation.across_checkout(room_id: room_id, checkout: checkout)
    between_checkin_checkout = Reservation.between_checkin_checkout(room_id: room_id, checkin: checkin, checkout: checkout)

    if across_checkin.present?
      have_reserved = Reservation.find_by("room_id = ? and checkin <= ? and checkout >= ?", room_id, checkin, checkin)
    elsif across_checkout.present?
      have_reserved = Reservation.find_by("room_id = ? and checkin <= ? and checkout >= ?", room_id, checkout, checkout)
    elsif between_checkin_checkout.present?
      have_reserved = Reservation.find_by("room_id = ? and checkin >= ? and checkout <= ?", room_id, checkin, checkout)
    end

    errors.add(:room_id, "恐れ入りますが、空室がございません。\newline予約済み1件 #{have_reserved.checkin} ~ #{have_reserved.checkout}") if have_reserved.present?
  end
end
