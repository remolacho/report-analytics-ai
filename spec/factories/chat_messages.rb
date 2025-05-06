# == Schema Information
#
# Table name: chat_messages
#
#  id           :integer          not null, primary key
#  active       :boolean          default(TRUE), not null
#  message      :string           not null
#  message_type :integer          not null
#  metadata     :json             not null
#  response     :string           not null
#  token        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chat_id      :integer          not null
#
# Indexes
#
#  index_chat_messages_on_chat_id  (chat_id)
#  index_chat_messages_on_token    (token) UNIQUE
#
# Foreign Keys
#
#  chat_id  (chat_id => chats.id)
#
FactoryBot.define do
  factory :chat_message do
    chat
    token { SecureRandom.uuid }
    message { FFaker::Lorem.sentence }
    message_type { 0 }
    response { FFaker::Lorem.paragraph }
    metadata { { timestamp: Time.current.to_i } }
    active { true }
  end
end
