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
  AI_MODEL = "gpt-3.5-turbo"

  has_many :chat_messages, dependent: :destroy

  validates :reference, presence: true, uniqueness: true
  validates :token, presence: true

  scope :active, -> { where(active: true) }
end
