# == Schema Information
#
# Table name: chats
#
#  id         :integer          not null, primary key
#  active     :boolean          default(TRUE), not null
#  reference  :string           not null
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chats_on_token  (token) UNIQUE
#
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
