# This migration comes from highlands_auth (originally 20151103030232)
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :first_name
      t.string :last_name
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
  end
end
