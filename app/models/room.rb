class Room < ApplicationRecord
  belongs_to       :user
  has_many         :reservations, dependent: :destroy
  has_many         :rates,        dependent: :destroy
  has_one          :price,        dependent: :destroy
  has_one_attached :room_image

  validates :name, presence: { message: "が未入力です" }, on: :create
  validates :introduction, presence: { message: "が未入力です" }, on: :create
  validates :fee, presence: { message: "が未入力です" }, on: :create
  validates :adress, presence: { message: "が未入力です" }, on: :create
  validates :fee, numericality: { greater_than_or_equal_to: 1000, message: "は1泊1000円以上で設定してください" },
                  on: :create
  validates :room_image,  presence: { message: "を登録してください" },
                          content_type: ['image/png', 'image/jpeg', 'image/jpg'],
                          dimension: {
                            width: { max: 1000 },
                            height: { max: 1000 }, message: 'は幅1000px以内の画像を使用してください',
                          },
                          size: {
                            less_than_or_equal_to: 1.megabytes,
                            message: 'は1つのファイル1MB以内にしてください',
                          },
                          on: :create

  MIN_NUM_RATES_SHARED = 2
  MAX_NUM_PRICE_RANGE = 7
  MIN_NUM_PRICE_RANGE = 1

  def self.ransackable_attributes(auth_object = {})
    %w(name introduction adress)
  end

  def self.ransackable_attribules(auth_object = {})
    []
  end

  # 物件の偏差値を返す
  def calculate_deviation
    rates = Rate.where(price_category: price.range)

    if rates.present?
      group_scores_ary = rates.pluck(:score)
      group_avg = rates.average(:score)&.round(2)

      # 標準偏差を返す
      group_gap_ary = group_scores_ary.map { |score| (score - group_avg)**2 }
      std = Math.sqrt(group_gap_ary.sum / group_gap_ary.length)

      if !std.zero?
        avg = calculate_avg                              # 平均スコアを返す
        (((avg - group_avg) * 10 / std) + 50).round      # 公式に当てはめて偏差値を返す
      else
        50 # 標準偏差が0の時はばらつきがないため、全ての要素は偏差値50となる
      end
    end
  end

  def round_group_avg
    if above_group_avg && under_group_avg
      return ((above_group_avg + under_group_avg + group_avg) / 3).round(2)
    end

    if above_group_avg
      return ((above_group_avg + group_avg) / 2).round(2)
    end

    if under_group_avg
      ((under_group_avg + group_avg) / 2).round(2)
    end
  end

  def calculate_avg
    rates.where(price_category: price.range).average(:score)&.round(2) if rates.present?
  end

  def calculate_cleanliness_avg
    rates.where(price_category: price.range).average(:cleanliness)&.round(2) if rates.present?
  end

  def calculate_information_avg
    rates.where(price_category: price.range).average(:information)&.round(2) if rates.present?
  end

  def calculate_communication_avg
    rates.where(price_category: price.range).average(:communication)&.round(2) if rates.present?
  end

  def calculate_location_avg
    rates.where(price_category: price.range).average(:location)&.round(2) if rates.present?
  end

  def calculate_price_avg
    rates.where(price_category: price.range).average(:price)&.round(2) if rates.present?
  end

  def calculate_recommendation_avg
    rates.where(price_category: price.range).average(:recommendation)&.round(2) if rates.present?
  end

  # 過去の評価件数が2以上であればtrueを返し、viewに表示する
  def has_min_num_rates?
    rates.size >= MIN_NUM_RATES_SHARED
  end

  # Bestスポットが付いた評価の件数を返す
  def count_awards
    num_awards = 0
    rates.each do |rate|
      if rate.award == true
        num_awards += 1
      end
    end

    num_awards
  end

  private

  def group_avg
    Rate.where(price_category: price.range).average(:score)&.round(2)
  end

  def above_group_avg
    if price.range != MAX_NUM_PRICE_RANGE
      above_price = price.range + 1
      Rate.where(price_category: above_price).average(:score)&.round(2)
    elsif false
    end
  end

  def under_group_avg
    if price.range != MIN_NUM_PRICE_RANGE
      under_price = price.range - 1
      Rate.where(price_category: under_price).average(:score)&.round(2)
    elsif false
    end
  end
end
