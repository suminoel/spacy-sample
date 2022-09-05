class AddOgCardToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :og_card, :text, after: :html_content
  end
end
