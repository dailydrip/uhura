# Receivers is a temporary table.  When we get the data from Highlands SSO we'll remove the receivers table.
class CreateReceivers < ActiveRecord::Migration[6.0]
  def change
    create_table :receivers do |t|
      t.bigint :receiver_sso_id # Highlands SSO ID
      t.string :email
      t.string :mobile_number
      t.string :first_name
      t.string :last_name
      t.json   :preferences

      t.timestamps null: false
    end
    add_index :receivers, :receiver_sso_id, unique: true
    add_index :receivers, :email, unique: true
  end
end
