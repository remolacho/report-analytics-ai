# == Schema Information
#
# Table name: chat_messages
#
#  id                  :integer          not null, primary key
#  active              :boolean          default(TRUE), not null
#  message             :string           not null
#  message_type        :integer          not null
#  metadata            :json             not null
#  token               :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  chat_id             :integer          not null
#  previous_message_id :integer
#
# Indexes
#
#  index_chat_messages_on_chat_id              (chat_id)
#  index_chat_messages_on_previous_message_id  (previous_message_id)
#  index_chat_messages_on_token                (token) UNIQUE
#
# Foreign Keys
#
#  chat_id              (chat_id => chats.id)
#  previous_message_id  (previous_message_id => chat_messages.id)
#
FactoryBot.define do
  factory :chat_message do
    chat
    token { SecureRandom.uuid }
    message { FFaker::Lorem.sentence }
    message_type { 'user' }
    metadata do
      {
        role: 'user',
        message: FFaker::Lorem.sentence,
        action: 'text',
        timestamp: Time.current.strftime("%Y-%m-%d %H:%M:%S")
      }
    end
    active { true }
  end
end
