class RenamePriceCategoryToPriceRangeColumns < ActiveRecord::Migration[6.1]
  def change
    rename_column :rates, :price_category, :price_range
  end
end
