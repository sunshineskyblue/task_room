class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :image
  has_many :rooms,
    dependent: :destroy
  has_many :guest_reservations,
    class_name: 'Reservation',
    foreign_key: 'guest_id',
    dependent: :destroy
  has_many :host_reservations,
    class_name: 'Reservation',
    foreign_key: 'host_id',
    dependent: :destroy
  has_many :guest_notifications,
    class_name: 'Notification',
    foreign_key: 'guest_id'
  has_many :host_notifications,
    class_name: 'Notification',
    foreign_key: 'host_id'
  has_many :rates

  validates :name, length: { in: 3..15, message: "は3文字以上15文字以内で入力してください" }, on: :update
  validates :introduction, presence: { message: "が未入力です" }, on: :update
  validates :image, content_type: ['image/png', 'image/jpeg', 'image/jpg'],
                    dimension: {
                      width: { max: 1000 },
                      height: { max: 1000 }, message: 'は幅1000px以内の画像を使用してください',
                    },
                    size: { less_than_or_equal_to: 1.megabytes, message: 'は1つのファイル1MB以内にしてください' },
                    on: :update

  validate :guest_user?, on: :update

  def ensure_not_in_guest
    if guest_reservations.where(cancel: false).present?
      errors.add(:base, "予約が残っております。キャンセルしてから退会してください")
    end
  end

  def ensure_not_in_host
    if host_reservations.where(cancel: false).present?
      errors.add(:base, "ホストとして予約を受付中です。\n
        ゲストのキャンセル手続き完了後、退会可能です。\n
        まずはキャンセルリクストを送信してください")
    end
  end

  def guest_user?
    if name == "ゲストユーザー" || email == "guest_user@example.com"
      errors.add(:base, "ゲストユーザーは変更・退会ができません")
    end
  end

  def has_active_reservations_cancel_requested_as_guest?
    guest_reservations.
      any? { |reservation| reservation.cancel_requested? && !reservation.finished? }
  end

  def has_passed_reservations_cancel_requested_as_guest?
    guest_reservations.
      any? { |reservation| reservation.cancel_requested? && reservation.finished? }
  end

  def has_active_reservations_cancel_requested_as_host?
    host_reservations.
      any? { |reservation| reservation.cancel_requested? && !reservation.finished? }
  end

  def has_passed_reservations_cancel_requested_as_host?
    host_reservations.
      any? { |reservation| reservation.cancel_requested? && reservation.finished? }
  end

  def has_cancel_notifications_unchecked_as_host?
    host_reservations.each do |reservation|
      if reservation.notifications.action_unchecked(action: "cancel").present?
        return true
      end
    end

    false
  end

  def has_active_notifications_unchecked_as_host?(action:)
    host_reservations.each do |reservation|
      if reservation.notifications.action_unchecked(action: action).present? &&
        !reservation.finished?
        return true
      end
    end

    false
  end

  def has_passed_notifications_unchecked_as_host?(action:)
    host_reservations.each do |reservation|
      if reservation.notifications.action_unchecked(action: action).present? &&
        reservation.finished?
        return true
      end
    end

    false
  end
end
