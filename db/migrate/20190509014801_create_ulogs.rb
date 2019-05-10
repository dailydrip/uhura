class CreateUlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :ulogs do |t|
      t.references :source, null: false, foreign_key: true
      t.references :event_type, null: false, foreign_key: true
      t.text :details

      t.timestamps
    end
  end
end
