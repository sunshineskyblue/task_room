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

  def create_price!
    range = switch_price_range

    Price.create!(
      room_id: id,
      value: fee,
      range: range,
    )
  end

  private

  def switch_price_range
    if fee < 5000
      1
    elsif fee < 10000
      2
    elsif fee < 20000
      3
    elsif fee < 40000
      4
    elsif fee < 60000
      5
    elsif fee < 100000
      6
    else
      7
    end
  end
end
