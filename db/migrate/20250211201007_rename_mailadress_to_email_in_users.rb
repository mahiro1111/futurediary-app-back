#Usersのカラム変更
class RenameMailadressToEmailInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :mailadress, :email
  end
end
