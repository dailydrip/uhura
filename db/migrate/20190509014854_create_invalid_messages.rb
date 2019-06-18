class CreateInvalidMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :invalid_messages do |t|
      t.references :msg_target, null: true
      t.references :manager, null: true
      t.references :receiver, null: true
      t.references :team, null: true
      t.string :email_subject
      t.text :email_message
      t.json :email_options
      t.references :template, null: true
      t.text :sms_message
      t.json :message_params # params has sent to messages_controller
      t.json :message_attrs  # message_vo instance varialbes

      t.timestamps
    end
  end
end
