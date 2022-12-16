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

  describe '#disallow_second_award_within_year' do
    let(:impressed_user) { create(:user) }
    let(:today) { Date.today }
    let(:next_award_rate) { build(:rate, user: impressed_user, award: true, created_at: today) }

    context '過去1年以内にベスト評価がない場合' do
      let(:one_year_ago) { today - 1.year }
      let!(:award_rate_one_year_ago) do
        create(:rate, user: impressed_user, award: true, created_at: one_year_ago)
      end

      it '次の評価は許可されること' do
        expect(next_award_rate).to be_valid
      end
    end

    context '過去1年以内にベスト評価がある場合' do
      let(:less_than_one_year) { today - 1.year + 1.day }
      let!(:award_rate_within_one_year) do
        create(:rate, user: impressed_user, award: true, created_at: less_than_one_year)
      end

      it '次の評価は許可されないこと' do
        expect(next_award_rate).to be_invalid
      end
    end
  end
end
