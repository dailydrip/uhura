class CreateClearstreamMsgEvents < ActiveRecord::Migration[6.0]
  def change
    #create_table :clearstream_msg_events, id: :uuid do |t|
    create_table :clearstream_msg_events do |t|
      t.references :clearstream_msg, null: true, type: :uuid, foreign_key: true
      t.string :status
      t.json :event_details

      t.timestamps
    end
  end
end
