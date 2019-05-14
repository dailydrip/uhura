class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :x_team_id
      t.string :email

      t.timestamps
    end
    add_index :teams, :name, unique: true
    add_index :teams, :x_team_id, unique: true
    add_index :teams, :email
  end
end
