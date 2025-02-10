class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.date :date
      t.datetime :dateTime
      t.string :timeZone
      t.string :summary

      t.timestamps
    end
  end
end
