require 'rails_helper'

RSpec.describe Price, type: :model do
  let!(:price) { build(:price) }

  describe '#switch_price_range' do
    it 'valueに応じてrangeが決定されること' do
      price.value = 4999
      price.switch_price_range
      expect(price.range).to eq 1
    end
  end
end
