class AddLikesCountToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :likes_count, :integer, default: 0
    add_column :posts, :reply_name, :string
  end
end
