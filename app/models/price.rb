class Price < ApplicationRecord
  belongs_to :room

  validates :value,
    numericality: { greater_than_or_equal_to: 1000, message: "は1泊1000円以上で設定してください" },
    on: :create
end
