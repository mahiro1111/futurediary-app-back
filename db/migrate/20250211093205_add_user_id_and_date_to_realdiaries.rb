#Realdiariesのカラム追加
class AddUserIdAndDateToRealdiaries < ActiveRecord::Migration[7.1]
  def change
    add_reference :realdiaries, :user, null: false, foreign_key: true
    add_column :realdiaries, :date, :date
  end
end
