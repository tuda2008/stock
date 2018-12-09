class ChangeIndexToUsers < ActiveRecord::Migration[5.2]
  def change
  	remove_index :users, :email
  	remove_index :users, :mobile

  	add_index :users, :email
    add_index :users, :mobile
  end
end