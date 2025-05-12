class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.string :token, null: false, index: { unique: true }
      t.string :reference, null: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end
  end
end
