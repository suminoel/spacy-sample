class AddCommentColumnToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :reply_user_id, :integer
    add_column :posts, :reply_parent_id, :integer
  end
end
