class CreateReceivers < ActiveRecord::Migration[6.0]
  def change
    create_table :receivers do |t|
      t.string :email
      t.string :mobile_number # Uhura unique

      t.timestamps null: false
    end
    add_index :receivers, :email, unique: true
  end
end
