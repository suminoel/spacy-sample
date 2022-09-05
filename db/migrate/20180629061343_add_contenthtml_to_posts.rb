class AddContenthtmlToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :html_content, :text, after: :content
  end
end
