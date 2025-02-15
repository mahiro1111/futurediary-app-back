#schedulesのカラム変更
class ModifySchedulesTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :schedules, :dateTime, :datetime  # dateTimeカラムを削除
    add_column :schedules, :start_time, :datetime   # start_timeを追加
    add_column :schedules, :end_time, :datetime     # end_timeを追加
    add_reference :schedules, :user, null: false, foreign_key: true  # user_idを追加
  end
end
