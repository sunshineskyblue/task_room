class Room < ApplicationRecord
  belongs_to       :user
  has_many         :reservations, dependent: :destroy
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

  def self.ransackable_attributes(auth_object = {})
    %w(name introduction adress)
  end

  def self.ransackable_attribules(auth_object = {})
    []
  end

  def calculate_deviation
    # 当物件の平均スコアを算出
    avg = rates.where(price_category: price.range).average(:score)

    # 当物件が属する集団の平均スコアを算出
    group = Rate.where(price_category: price.range)
    group_scores_ary = group.pluck(:score)           # 計測未実施
    group_avg = group.average(:score)                # 計測未実施

    # 標準偏差を算出  //配列要素10万での計測結果 => 約0.06s
    group_gap_ary = group_scores_ary.map { |score| (score - group_avg)**2 }
    std = Math.sqrt(group_gap_ary.sum / group_gap_ary.length)

    # 当物件の偏差値を算出
    (((avg - group_avg) * 10 / std) + 50).round
  end
end
