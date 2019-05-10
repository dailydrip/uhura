class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :sendgrid_msg, null: true, foreign_key: true
      t.references :clearstream_msg, null: true, foreign_key: true
      t.references :manager, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.string :email_subject
      t.text :email_message
      t.references :template, null: false, foreign_key: true
      t.text :sms_message

      t.timestamps
    end
  end
end
