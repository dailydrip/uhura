class CreateTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :templates do |t|
      t.string :name
      t.string :template_id
      t.json :sample_template_data

      t.timestamps
    end
    add_index :templates, :name, unique: true
  end
end
