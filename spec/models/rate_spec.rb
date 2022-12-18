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
    let(:user) { create(:user) }
    let(:today) { Date.today }
    let(:next_award_rate) { build(:rate, user: user, award: true, created_at: today) }

    # 例) 2022年1月1日（ベスト評価日）の場合 => 2023年1月1日以降 、評価再開

    context '本日が直近のベスト評価日から数えて1年目以降の場合' do
      let(:one_year_ago) { today - 1.year }
      let!(:past_award_rate) do
        create(:rate, user: user, award: true, created_at: one_year_ago)
      end

      it '次のベスト評価は許可されること' do
        expect(next_award_rate).to be_valid
      end
    end

    context '本日が直近のベスト評価日から数えて1年未満の場合' do
      let(:less_than_one_year) { today - 1.year + 1.day }
      let!(:past_award_rate) do
        create(:rate, user: user, award: true, created_at: less_than_one_year)
      end
      let(:none_award_rate) { build(:rate, user: user, award: false, created_at: today) }

      it '次のベスト評価は許可されないこと' do
        expect(next_award_rate).to be_invalid
      end

      it 'ベスト評価を付けていない評価については、許可されること' do
        expect(none_award_rate).to be_valid
      end
    end
  end
end
