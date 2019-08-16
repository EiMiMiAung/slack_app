class CreateHChastarmsgs < ActiveRecord::Migration[5.2]
  def change
    create_table :h_chastarmsgs do |t|
      t.integer :chamsg_id
      t.integer :user_id

      t.timestamps
    end
  end
end
