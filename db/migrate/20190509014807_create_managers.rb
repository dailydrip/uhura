class CreateManagers < ActiveRecord::Migration[6.0]
  def change
    create_table :managers do |t|
      t.string :name
      t.string :public_token
      t.string :email

      t.timestamps
    end
    add_index :managers, :name, unique: true
    add_index :managers, :public_token, unique: true
    add_index :managers, :email
  end
end
