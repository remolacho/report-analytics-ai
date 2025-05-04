class Chat < ApplicationRecord
  has_many :chat_messages, dependent: :destroy

  validates :token, :reference, presence: true
  validates :token, uniqueness: true

  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.uuid
  end
end
