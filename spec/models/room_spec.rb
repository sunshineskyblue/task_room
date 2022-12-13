require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#calculate_deviation' do
    let(:room) { create(:room) }
    let!(:price) { build(:price, value: 1000, range: 1, room: room) }
    let!(:rate) do
      create_list(:rate,
        2,
        room: room,
        cleanliness: 4.5,
        information: 4.5,
        location: 4.5,
        communication: 4.5,
        recommendation: 4.5,
        price: 4.5,
        score: 4.5,
        price_category: 1)
    end

    let!(:rate_5) do
      create_list(:rate,
        2,
        cleanliness: 5,
        information: 5,
        location: 5,
        communication: 5,
        recommendation: 5,
        price: 5,
        score: 5,
        price_category: 1)
    end

    let!(:rate_4) do
      create_list(:rate,
        2,
        cleanliness: 4,
        information: 4,
        location: 4,
        communication: 4,
        recommendation: 4,
        price: 4,
        score: 4,
        price_category: 1)
    end

    it '偏差値が返されること' do
      expect(room.calculate_deviation).to eq 50
    end
  end
end
