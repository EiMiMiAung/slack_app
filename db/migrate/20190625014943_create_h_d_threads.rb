class CreateHDThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :h_d_threads do |t|
      t.integer :dmsg_id
      t.integer :user_id
      t.string :thread_msg
      t.integer :count

      t.timestamps
    end
  end
end
