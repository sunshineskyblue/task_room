class AddIndexForPreventSameReservation < ActiveRecord::Migration[6.1]
  def change
    add_index :reservations, [:user_id, :room_id, :checkin, :checkout], unique:true,
    name: :prevent_same_reservation
  end
end
