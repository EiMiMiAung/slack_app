class CreateHDstarmsgs < ActiveRecord::Migration[5.2]
  def change
    create_table :h_dstarmsgs do |t|
      t.integer :dmsg_id
      t.integer :user_id

      t.timestamps
    end
  end
end
