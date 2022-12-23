class ChangeDataUserIdToRooms < ActiveRecord::Migration[6.1]
  def change
    change_column :rooms, :user_id, :
  end
end
