class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.date :day_start, null:false
      t.date :day_end, null:false
      t.integer :number, null:false
      t.integer :payment, null:false
      t.integer :user_id, null:false
      t.integer :room_id, null:false

      t.timestamps
    end
  end
end
