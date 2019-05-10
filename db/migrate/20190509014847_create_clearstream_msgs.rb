class CreateClearstreamMsgs < ActiveRecord::Migration[6.0]
  def change
    create_table :clearstream_msgs do |t|
      t.datetime :sent_to_clearstream
      t.text :clearstream_response

      t.timestamps
    end
  end
end
