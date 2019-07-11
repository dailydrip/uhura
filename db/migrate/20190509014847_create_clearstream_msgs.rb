class CreateClearstreamMsgs < ActiveRecord::Migration[6.0]
  def change
    create_table :clearstream_msgs, id: :uuid do |t|
      t.datetime :sent_to_clearstream
      t.json :response
      t.datetime :got_response_at
      t.text :status
      t.integer :clearstream_id

      t.timestamps
    end
  end
end
