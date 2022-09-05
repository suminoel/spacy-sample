class RemoveUniqueKeyFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, :user_name
    add_index :users, :user_name
  end
end
