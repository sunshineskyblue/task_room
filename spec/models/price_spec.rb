require 'rails_helper'

RSpec.describe Price, type: :model do
  let!(:price) { build(:price) }

  describe '#switch_price_range' do
    it 'valueに応じてrangeが決定されること' do
      price.value = 4999
      price.switch_price_range
      expect(price.range).to eq 1

      price.value = 9999
      price.switch_price_range
      expect(price.range).to eq 2

      price.value = 19999
      price.switch_price_range
      expect(price.range).to eq 3

      price.value = 39999
      price.switch_price_range
      expect(price.range).to eq 4

      price.value = 59999
      price.switch_price_range
      expect(price.range).to eq 5

      price.value = 99999
      price.switch_price_range
      expect(price.range).to eq 6

      price.value = 100000
      price.switch_price_range
      expect(price.range).to eq 7
    end
  end
end
