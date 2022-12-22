class AddColumnPriceValueToRates < ActiveRecord::Migration[6.1]
  def change
    add_column :rates, :price_value, :integer
  end
end
