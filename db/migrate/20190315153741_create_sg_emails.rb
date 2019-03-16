class CreateSgEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :sg_emails do |t|
      t.string :from_email
      t.string :to_email
      t.string :subject
      t.text :content
      t.string :response_status_code

      t.timestamps
    end

  end
end