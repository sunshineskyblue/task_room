class Rate < ApplicationRecord
  NUM_OF_EVALUATION_CRITERIA = 6

  belongs_to :room
  belongs_to :user

  validates :cleanliness,    presence: { message: "が未入力です" },
                             numericality: { in: 1..5 }, on: :create
  validates :information,    presence: { message: "が未入力です" },
                             numericality: { in: 1..5 }, on: :create
  validates :communication,  presence: { message: "が未入力です" },
                             numericality: { in: 1..5 }, on: :create
  validates :location,       presence: { message: "が未入力です" },
                             numericality: { in: 1..5 }, on: :create
  validates :price,          presence: { message: "が未入力です" },
                             numericality: { in: 1..5 }, on: :create
  validates :recommendation, presence: { message: "が未入力です" },
                             numericality: { in: 1..5 }, on: :create

  validate :disallow_second_award_within_year

  def calculate_score
    self.score = ((
        cleanliness.to_f +
        information.to_f +
        communication.to_f +
        location.to_f +
        price.to_f +
        recommendation.to_f
      ) / NUM_OF_EVALUATION_CRITERIA).
      round(2)
  end

  private

  def disallow_second_award_within_year
    one_year_ago = Date.today - 1.year
    number = Rate.
      where(award: true).
      where(user_id: user.id).
      where('created_at > ?', one_year_ago)

    if number.size >= 1
      return true
    end

    false
  end
end
