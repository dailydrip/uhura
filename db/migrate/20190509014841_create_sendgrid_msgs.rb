class CreateSendgridMsgs < ActiveRecord::Migration[6.0]
  def change
    create_table :sendgrid_msgs, id: :uuid do |t|
      t.datetime :sent_to_sendgrid
      t.json :mail_and_response
      t.datetime :got_response_at
      t.text :sendgrid_response
      t.datetime :read_by_user_at
      t.text :status # <= Added in anticipation of async sending of email

      t.timestamps
    end
  end
end
