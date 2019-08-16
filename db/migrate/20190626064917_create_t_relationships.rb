class CreateTRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :t_relationships do |t|
      t.integer :user_id
      t.integer :workspace_id
      t.integer :cha_id
      t.boolean :isdeactivated
      t.integer :msg_count

      t.timestamps
    end
  end
end
