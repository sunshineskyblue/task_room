class AddUniqueIndexToReservations < ActiveRecord::Migration[6.1]
  def change
    add_index :reservations, [:user_id, :room_id, :day_end, :day_start], unique:true,
      name: "prevent resevation for same room on same day by same user"
  end
end
