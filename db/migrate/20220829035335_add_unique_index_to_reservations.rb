class AddUniqueIndexToReservations < ActiveRecord::Migration[6.1]
  def change
    add_index :reservations, [:user_id, :room_id, :day_end, :day_start], unique:true,
      name: "reservation_per_user_uniq"
  end
end
