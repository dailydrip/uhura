class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :name_prefix
      t.string :email

      t.timestamps
    end
    add_index :teams, :name, unique: true
    add_index :teams, :name_prefix, unique: true
    add_index :teams, :email
  end
end
