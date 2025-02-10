class CreateRealdiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :realdiaries do |t|
      t.string :title
      t.text :diary

      t.timestamps
    end
  end
end
