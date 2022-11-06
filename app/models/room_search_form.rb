class RoomSearchForm
  include ActiveModel::Model
  validates :search_keywords, presence: true, if: :search_adress_blank?
  validates :search_adress, presence: true, if: :search_keywords_blank?

  attr_accessor :search_keywords, :search_adress, :search_area

  def initialize(arg)
    @search_keywords = arg[:room_name_or_room_intro_cont]
    @search_adress = arg[:adress_cont]
    @search_area = arg[:area_cont]
  end

  # and検索をする
  def search_and_condition
    Room.ransack({ combinator: 'and', groupings: grouping_keywords_adress }).result(distinct: true)
  end

  # or検索をする機能
  def search_or_condition
    Room.ransack({ combinator: 'or', groupings: grouping_adress }).result(distinct: true)
  end

  # 検索ワードをページタイトルに挿入する
  def link_adress_keywords
    if !search_adress_blank? && !search_keywords_blank?
      search_adress + " " + search_keywords
    elsif !search_adress_blank? && search_keywords_blank?
      search_adress
    else
      search_keywords
    end
  end

  private

  def search_keywords_blank?
    search_keywords.blank?
  end

  def search_adress_blank?
    search_adress.blank?
  end

  def multi_keywords_to_ary
    search_keywords.split(/[\p{blank}\s]+/)  # \p{blank} => 全角空白に対応
  end

  def multi_adress_to_ary
    search_adress.split(/[\p{blank}\s]+/)
  end

  def grouping_keywords
    multi_keywords_to_ary&.
      reduce({}) { |hash, word| hash.merge(word => { room_name_or_room_intro_cont: word }) }
  end

  def grouping_adress
    multi_adress_to_ary&.reduce({}) { |hash, word| hash.merge(word => { adress_cont: word }) }
  end

  def grouping_keywords_adress
    grouping_keywords&.merge(grouping_adress)
  end
end
