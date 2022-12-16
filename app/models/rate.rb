class Rate < ApplicationRecord
  NUM_OF_RATE_POINTS = 6

  belongs_to :room
  belongs_to :user

  validates :cleanliness, numericality: {
    in: 1..5,
    message: ": 1から5までの間で入力してください",
  }, on: :create
  validates :information, numericality: {
    in: 1..5,
    message: ": 1から5までの間で入力してください",
  }, on: :create
  validates :communication, numericality: {
    in: 1..5,
    message: ": 1から5までの間で入力してください",
  }, on: :create
  validates :location, numericality: {
    in: 1..5,
    message: ": 1から5までの間で入力してください",
  }, on: :create
  validates :price, numericality: {
    in: 1..5,
    message: ": 1から5までの間で入力してください",
  }, on: :create
  validates :recommendation, numericality: {
    in: 1..5,
    message: ": 1から5までの間で入力してください",
  }, on: :create

  validates :award, inclusion: { in: [true, false] }, on: :create

  validate :disallow_second_award_within_year

  def calculate_score
    self.score = ((
        cleanliness.to_f +
        information.to_f +
        communication.to_f +
        location.to_f +
        price.to_f +
        recommendation.to_f
      ) / NUM_OF_RATE_POINTS).
      round(2)
  end

  def double_rate?
    first_rate = Rate.where(reservation_id: reservation_id)

    if first_rate.present?
      return true
    end

    false
  end

  private

  def disallow_second_award_within_year
    one_year_ago = Date.today - 1.year
    num_award = Rate.
      where(user_id: user_id).
      where('created_at > ?', one_year_ago).
      where(award: true)

    if num_award.size >= 1
      reenable_date = (num_award.first.created_at + 1.year).strftime("%Y年%m月%d日")
      errors.add(:award, ": #{reenable_date}から可能です")
    end
  end
end
