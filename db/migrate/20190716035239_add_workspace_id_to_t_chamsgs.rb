class AddWorkspaceIdToTChamsgs < ActiveRecord::Migration[5.2]
  def change
    add_column :t_chamsgs, :workspace_id, :integer
  end
end
