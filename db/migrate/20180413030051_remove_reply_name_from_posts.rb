class RemoveReplyNameFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :reply_name
  end
end
