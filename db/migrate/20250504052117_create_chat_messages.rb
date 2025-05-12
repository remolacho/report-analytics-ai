class CreateChatMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :previous_message, null: true, foreign_key: { to_table: :chat_messages }
      t.string :token, null: false
      t.string :message, null: false
      t.integer :message_type, null: false
      t.json :metadata, null: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_index :chat_messages, :token, unique: true
  end
end
