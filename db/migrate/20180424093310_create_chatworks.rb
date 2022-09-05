class CreateChatworks < ActiveRecord::Migration[5.1]
  def change
    create_table :chatworks do |t|

      t.timestamps
    end
  end
end
