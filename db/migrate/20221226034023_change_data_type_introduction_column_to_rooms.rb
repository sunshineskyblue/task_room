class ChangeDataTypeIntroductionColumnToRooms < ActiveRecord::Migration[6.1]
  def up
    change_column :rooms, :introduction, :text
  end

  def down
    change_column :rooms, :introduction, :string
  end
end
