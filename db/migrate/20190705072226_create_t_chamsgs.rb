class CreateTChamsgs < ActiveRecord::Migration[5.2]
  def change
    create_table :t_chamsgs do |t|
      t.integer :sender_id
      t.integer :cha_id
      t.string :msg

      t.timestamps
    end
  end
end
