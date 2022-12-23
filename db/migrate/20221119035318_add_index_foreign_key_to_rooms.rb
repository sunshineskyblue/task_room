class AddIndexForeignKeyToRooms < ActiveRecord::Migration[6.1]
  def change
    add_index :rooms, :user_id
  end
end
