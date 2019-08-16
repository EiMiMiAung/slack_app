class CreateHMentions < ActiveRecord::Migration[5.2]
  def change
    create_table :h_mentions do |t|
      t.integer :user_id
      t.integer :chamsg_id

      t.timestamps
    end
  end
end
