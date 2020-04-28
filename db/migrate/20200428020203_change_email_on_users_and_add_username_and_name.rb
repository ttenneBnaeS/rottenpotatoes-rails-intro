class ChangeEmailOnUsersAndAddUsernameAndName < ActiveRecord::Migration
  def change
    change_column :users, :email, :string, null: true
    add_column :users, :username, :string
    add_column :users, :name, :string
  end
end
