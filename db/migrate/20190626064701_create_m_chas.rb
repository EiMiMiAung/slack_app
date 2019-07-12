class CreateMChas < ActiveRecord::Migration[5.2]
  def change
    create_table :m_chas do |t|
      t.string :name
      t.boolean :isprivate
      t.integer :workspace_id

      t.timestamps
    end
  end
end
