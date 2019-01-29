class ChangeUsersColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :admin, :boolean, default: false
    remove_column :users, :password
  end
end
