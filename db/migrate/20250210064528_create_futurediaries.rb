class CreateFuturediaries < ActiveRecord::Migration[7.1]
  def change
    create_table :futurediaries do |t|
      t.text :diary

      t.timestamps
    end
  end
end
