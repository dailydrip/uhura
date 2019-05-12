class CreateReceivers < ActiveRecord::Migration[6.0]
  def change
    create_table :receivers do |t|
      t.string :email
      t.string :mobile_number # Uhura unique
      t.string :first_name
      t.string :last_name
      t.json :preferences     # Uhura unique
      # New Administrate columns
      t.string :username
      t.string :gender
      t.integer :household_id
      t.string :token
      t.string :secret
      t.string :url
      t.string :type
      t.json :data
      t.string :slug
      t.string :last_sign_in_ip
      t.datetime :last_sign_in_at
      t.boolean :admin,      :default => false
      t.boolean :superadmin, :default => false
      t.boolean :editor,     :default => false

      t.timestamps null: false
    end
    add_index :receivers, :email, unique: true
  end
end
