class CreateSources < ActiveRecord::Migration[6.0]
  def change
    create_table :sources do |t|
      t.string :name
      t.json :details

      t.timestamps
    end
    add_index :sources, :name, unique: true
  end
end
