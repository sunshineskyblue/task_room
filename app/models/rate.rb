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

  private

  def disallow_second_award_within_year
    one_year_ago = Date.today - 1.year
    number = Rate.
      where(user_id: user.id).
      where('created_at > ?', one_year_ago).
      where(award: true)

    if number.size >= 1
      return true
    end

    false
  end
end
