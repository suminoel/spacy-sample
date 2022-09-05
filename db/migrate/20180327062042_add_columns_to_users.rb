class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user_dept, :string
  end
end
