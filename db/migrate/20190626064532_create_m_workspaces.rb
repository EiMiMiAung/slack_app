class CreateMWorkspaces < ActiveRecord::Migration[5.2]
  def change
    create_table :m_workspaces do |t|
      t.integer :user_id
      t.string :workspace_name

      t.timestamps
    end
  end
end
