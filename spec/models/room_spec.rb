require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#calculate_avg' do
    before do
      price.switch_price_range
    end

    let(:price) { build(:price, value: 1000) }
    let(:room) { create(:room, price: price) }
    let!(:rate_2021) do
      create(:rate,
        room: room,
        cleanliness: 4,
        information: 4,
        location: 4,
        communication: 4,
        recommendation: 4,
        price: 4,
        score: 4)
    end
    let!(:rate_2022) do
      create(:rate,
        room: room,
        cleanliness: 5,
        information: 5,
        location: 5,
        communication: 5,
        recommendation: 5,
        price: 5,
        score: 5)
    end

    it '平均スコアが返されること' do
      expect(room.calculate_avg).to eq 4.5
    end
  end

  describe '#count_awards' do
    let(:room) { create(:room) }
    let!(:award_rates) { create_list(:rate, 5, room: room, award: true) }

    it 'ベスト評価の付いた評価の件数が返されること' do
      expect(room.count_awards).to eq 5
    end
  end

  describe '#has_min_num_rates?' do
    let(:min_num) { 2 }
    let(:room) { create(:room) }
    let!(:rates) { create_list(:rate, min_num, room: room) }

    it '過去の評価件数が2件以上であればtrueを返すこと' do
      expect(room.has_min_num_rates?).to eq true
    end

    context '過去の評価件数が1件以下の場合' do
      let(:new_room) { create(:room) }
      let!(:rate) { create(:rate, room: new_room) }

      it 'falseを返すこと' do
        expect(new_room.has_min_num_rates?).to eq false
      end
    end
  end

  describe '#calculate_deviation' do
    before do
      price.switch_price_range
    end

    let(:price) { build(:price, value: 1000) }
    let(:room) { create(:room, price: price) }
    let(:room_price_range) { room.price.range }
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
        score: 4.5,)
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
        price_category: room_price_range)
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
        price_category: room_price_range)
    end

    it '偏差値が返されること' do
      expect(room.calculate_deviation).to eq 50
    end
  end
end
