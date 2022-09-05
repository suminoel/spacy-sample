class AddChatworkIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :chatwork, :integer, after: :user_name
  end
end
