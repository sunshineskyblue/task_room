class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices do |t|
      t.references :room,     null: false
      t.integer :value,       null: false
      t.integer :range, null: false

      t.timestamps
    end
  end
end
