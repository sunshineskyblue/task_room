class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.references :room,           null: false
      t.references :user,           null: false
      t.references :reservation,    null: false
      t.integer    :price_category, null: false
      t.integer    :cleanliness,    null: false
      t.integer    :information,    null: false
      t.integer    :communication,  null: false
      t.integer    :location,       null: false
      t.integer    :price,          null: false
      t.integer    :recommendation, null: false
      t.float      :score,          null: false
      t.boolean    :award,          null: false, default: false

      t.timestamps
    end

    add_index :rates, :price_category
  end
end
