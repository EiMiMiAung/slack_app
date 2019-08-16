class CreateHChaStarmsgs < ActiveRecord::Migration[5.2]
  def change
    create_table :h_cha_starmsgs do |t|
      t.integer :chamsg_id
      t.integer :user_id

      t.timestamps
    end
  end
end
