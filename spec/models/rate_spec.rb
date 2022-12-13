require 'rails_helper'

RSpec.describe Rate, type: :model do
  describe '#calculate_score' do
    let(:rate) do
      build(:rate,
        cleanliness: 5,
        information: 5,
        location: 5,
        communication: 4,
        recommendation: 4,
        price: 4)
    end

    it '平均スコアが計算されること' do
      rate.calculate_score
      expect(rate.score).to eq 4.5
    end
  end
end
