class CreateMsgTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :msg_targets do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :msg_targets, :name, unique: true
  end
end
