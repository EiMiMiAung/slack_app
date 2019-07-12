class CreateTDmsgs < ActiveRecord::Migration[5.2]
  def change
    create_table :t_dmsgs do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :msg
      t.boolean :isread
      t.integer :workspace_id

      t.timestamps
    end
  end
end
