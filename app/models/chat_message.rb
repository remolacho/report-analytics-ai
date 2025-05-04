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
class ChatMessage < ApplicationRecord
  belongs_to :chat
  has_one_attached :file

  validates :token, :message, :message_type, :response, :metadata, presence: true
  validates :token, uniqueness: true

  before_create :generate_token

  enum message_type: {
    user: 0,
    assistant: 1
  }

  def file_url
    file.attached? ? Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) : nil
  end

  private

  def generate_token
    self.token = SecureRandom.uuid
  end
end
