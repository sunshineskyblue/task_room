require 'rails_helper'

RSpec.describe Room, type: :model do
  shared_context 'rate from 2021 to 2022' do
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
  end

  describe '#スコアを計算する' do
    before do
      price.switch_price_range
    end

    include_context 'rate from 2021 to 2022'

    describe '#calculate_avg' do
      it '総合スコアの平均が返されること' do
        expect(room.calculate_avg).to eq 4.5
      end
    end

    describe '#calculate_cleanliness_avg' do
      it '清潔さの平均スコアが返されること' do
        expect(room.calculate_cleanliness_avg).to eq 4.5
      end
    end

    describe '#calculate_information_avg' do
      it '掲載情報の正しさの平均スコアが返されること' do
        expect(room.calculate_information_avg).to eq 4.5
      end
    end

    describe '#calculate_communication_avg' do
      it 'コミュニケーションの平均スコアが返されること' do
        expect(room.calculate_communication_avg).to eq 4.5
      end
    end

    describe '#calculate_location_avg' do
      it 'ロケーションの平均スコアが返されること' do
        expect(room.calculate_location_avg).to eq 4.5
      end
    end

    describe '#calculate_price_avg' do
      it '価格の平均スコアが返されること' do
        expect(room.calculate_price_avg).to eq 4.5
      end
    end

    describe '#calculate_recommendation_avg' do
      it 'おすすめ度の平均スコアが返されること' do
        expect(room.calculate_recommendation_avg).to eq 4.5
      end
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

  describe '#integrate_group_avgs' do
    before do
      price.switch_price_range
    end

    let!(:price_range_1) do
      create_list(:rate,
        2,
        cleanliness: 2,
        information: 2,
        location: 2,
        communication: 2,
        recommendation: 2,
        price: 2,
        score: 2,
        price_category: 1)
    end

    let!(:price_range_2) do
      create_list(:rate,
        2,
        cleanliness: 2.5,
        information: 2.5,
        location: 2.5,
        communication: 2.5,
        recommendation: 2.5,
        price: 2.5,
        score: 2.5,
        price_category: 2)
    end

    let!(:price_range_3) do
      create_list(:rate,
        2,
        cleanliness: 3,
        information: 3,
        location: 3,
        communication: 3,
        recommendation: 3,
        price: 3,
        score: 3,
        price_category: 3)
    end

    let!(:price_range_4) do
      create_list(:rate,
        2,
        cleanliness: 3.5,
        information: 3.5,
        location: 3.5,
        communication: 3.5,
        recommendation: 3.5,
        price: 3.5,
        score: 3.5,
        price_category: 4)
    end

    let!(:price_range_5) do
      create_list(:rate,
        2,
        cleanliness: 4,
        information: 4,
        location: 4,
        communication: 4,
        recommendation: 4,
        price: 4,
        score: 4,
        price_category: 5)
    end

    let!(:price_range_6) do
      create_list(:rate,
        2,
        cleanliness: 4.5,
        information: 4.5,
        location: 4.5,
        communication: 4.5,
        recommendation: 4.5,
        price: 4.5,
        score: 4.5,
        price_category: 6)
    end

    let!(:price_range_7) do
      create_list(:rate,
        2,
        cleanliness: 5,
        information: 5,
        location: 2,
        communication: 5,
        recommendation: 5,
        price: 5,
        score: 5,
        price_category: 7)
    end

    context 'roomのrange（価格帯）が1の場合' do
      let(:price) { build(:price, value: 4999) }
      let(:room) { create(:room, price: price) }

      it 'price_category（価格帯）の1と2の平均が返されること' do
        expect(room.integrate_group_avgs).to eq 2.25
      end
    end

    context 'roomの価格帯(range)が2の場合' do
      let(:price) { build(:price, value: 9999) }
      let(:room) { create(:room, price: price) }

      it 'price_category（価格帯）の1と2と3の平均が返されること' do
        expect(room.integrate_group_avgs).to eq 2.5
      end
    end

    context 'roomの価格帯(range)が3の場合' do
      let(:price) { build(:price, value: 19999) }
      let(:room) { create(:room, price: price) }

      it 'price_category（価格帯）の2と3と4の平均が返されること' do
        expect(room.integrate_group_avgs).to eq 3
      end
    end

    context 'roomの価格帯(range)が4の場合' do
      let(:price) { build(:price, value: 39999) }
      let(:room) { create(:room, price: price) }

      it 'price_category（価格帯）の3と4と5の平均が返されること' do
        expect(room.integrate_group_avgs).to eq 3.5
      end
    end

    context 'roomの価格帯(range)が5の場合' do
      let(:price) { build(:price, value: 59999) }
      let(:room) { create(:room, price: price) }

      it 'price_category（価格帯）の4と5と6の平均が返されること' do
        expect(room.integrate_group_avgs).to eq 4
      end
    end

    context 'roomの価格帯(range)が6の場合' do
      let(:price) { build(:price, value: 99999) }
      let(:room) { create(:room, price: price) }

      it 'price_category（価格帯）の5と6と7の平均が返されること' do
        expect(room.integrate_group_avgs).to eq 4.5
      end
    end

    context 'roomの価格帯(range)が7の場合' do
      let(:price) { build(:price, value: 100000) }
      let(:room) { create(:room, price: price) }

      it 'price_category（価格帯）の6と7の平均が返されること' do
        expect(room.integrate_group_avgs).to eq 4.75
      end
    end
  end
end
