class CreateHChaThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :h_cha_threads do |t|
      t.integer :chamsg_id
      t.integer :user_id
      t.string :chathread_msg

      t.timestamps
    end
  end
end
