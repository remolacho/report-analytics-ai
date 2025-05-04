class ChatMessage < ApplicationRecord
  belongs_to :chat

  validates :token, :message, :message_type, :response, :metadata, presence: true
  validates :token, uniqueness: true

  before_create :generate_token

  enum message_type: {
    user: 0,
    assistant: 1
  }

  private

  def generate_token
    self.token = SecureRandom.uuid
  end
end
