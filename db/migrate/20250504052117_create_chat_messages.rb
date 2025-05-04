class CreateChatMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.string :token, null: false, index: { unique: true }
      t.string :message, null: false
      t.integer :message_type, null: false
      t.string :response, null: false
      t.jsonb :metadata, null: false, default: {}
      t.boolean :active, null: false, default: true
      t.timestamps
    end
  end
end
