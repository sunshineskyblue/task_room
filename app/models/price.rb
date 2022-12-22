class Price < ApplicationRecord
  belongs_to :room

  validates :value,
    numericality: { greater_than_or_equal_to: 1000, message: "は1泊1000円以上で設定してください" },
    on: :create

  def switch_price_range
    if value < 5000
      self.range = 1
    elsif value < 10000
      self.range = 2
    elsif value < 20000
      self.range = 3
    elsif value < 40000
      self.range = 4
    elsif value < 60000
      self.range = 5
    elsif value < 100000
      self.range = 6
    else
      self.range = 7
    end
  end
end
