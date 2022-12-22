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

  MIN_NUM_RATES_SHARED = 2  # 2件以上から評価を公開する
  MAX_NUM_PRICE_RANGE = 7   # Price rangeカラム（価格帯）の上限値
  MIN_NUM_PRICE_RANGE = 1   # Price rangeカラム（価格帯）の下限値

  def self.ransackable_attributes(auth_object = {})
    %w(name introduction adress)
  end

  def self.ransackable_attribules(auth_object = {})
    []
  end

  # Roomと紐づくPriceのrangeを呼び出す（価格帯情報を保持）
  # Rateテーブルのprice_rangeをrangeの前後の値で範囲指定し、whereで抽出する
  # scoreの平均を返す
  # => 価格帯ごとに総合評価の平均値が返される
  def integrate_group_avgs
    if price.range === MIN_NUM_PRICE_RANGE
      above_range = MIN_NUM_PRICE_RANGE + 1
      Rate.where(price_range: MIN_NUM_PRICE_RANGE..above_range).average(:score)&.round(2)
    elsif price.range === MAX_NUM_PRICE_RANGE
      under_range = MAX_NUM_PRICE_RANGE - 1
      Rate.where(price_range: under_range..MAX_NUM_PRICE_RANGE).average(:score)&.round(2)
    else
      under_range = price.range - 1
      above_range = price.range + 1
      Rate.where(price_range: under_range..above_range).average(:score)&.round(2)
    end
  end

  def calculate_avg
    if rates.present?
      rates.where(price_range: price.range). # 同じ価格帯で得た評価のみから平均を算出する
        average(:score)&.
        round(2)
    end
  end

  def calculate_cleanliness_avg
    rates.where(price_range: price.range).average(:cleanliness)&.round(2) if rates.present?
  end

  def calculate_information_avg
    rates.where(price_range: price.range).average(:information)&.round(2) if rates.present?
  end

  def calculate_communication_avg
    rates.where(price_range: price.range).average(:communication)&.round(2) if rates.present?
  end

  def calculate_location_avg
    rates.where(price_range: price.range).average(:location)&.round(2) if rates.present?
  end

  def calculate_price_avg
    rates.where(price_range: price.range).average(:price)&.round(2) if rates.present?
  end

  def calculate_recommendation_avg
    rates.where(price_range: price.range).average(:recommendation)&.round(2) if rates.present?
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
end
