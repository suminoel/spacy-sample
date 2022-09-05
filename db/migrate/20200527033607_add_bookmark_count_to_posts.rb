class AddBookmarkCountToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :bookmarks_count, :integer, :after => :likes_count, default: 0
  end
end
