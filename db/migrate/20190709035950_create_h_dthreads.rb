class CreateHDthreads < ActiveRecord::Migration[5.2]
  def change
    create_table :h_dthreads do |t|
      t.integer :dmsg_id
      t.integer :user_id
      t.string :thread_msg

      t.timestamps
    end
  end
end
