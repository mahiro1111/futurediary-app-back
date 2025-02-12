#Futurediariesのカラム追加
class AddColumnsToFuturediaries < ActiveRecord::Migration[7.1]
  def change
    add_column :futurediaries, :title, :string
    add_reference :futurediaries, :user, null: false, foreign_key: true
    add_column :futurediaries, :date, :date
  end
end
