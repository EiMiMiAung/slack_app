class CreateMUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :m_users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :activated

      t.timestamps
    end
  end
end
