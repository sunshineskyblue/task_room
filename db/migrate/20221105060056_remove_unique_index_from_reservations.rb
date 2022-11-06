class RemoveUniqueIndexFromReservations < ActiveRecord::Migration[6.1]
  def change
    # 不正なカラム
    add_column :reservations, :day_start, :date
    add_column :reservations, :day_end, :date
    # 不正なindex削除
    remove_index :reservations, name: "prevent resevation for same room on same day by same user"
    # 不整合解消用に作った一時カラムを削除
    remove_column :reservations, :day_start, :date
    remove_column :reservations, :day_end, :date
  end
end
