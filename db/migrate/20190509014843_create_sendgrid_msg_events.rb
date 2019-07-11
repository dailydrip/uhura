class CreateSendgridMsgEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :sendgrid_msg_events, id: :uuid do |t|
      t.references :sendgrid_msg, null: true, type: :uuid, foreign_key: true
      t.string :status
      t.json :event

      t.timestamps
    end
  end
end
