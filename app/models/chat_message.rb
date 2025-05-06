# == Schema Information
#
# Table name: chat_messages
#
#  id           :integer          not null, primary key
#  active       :boolean          default(TRUE), not null
#  message      :string           not null
#  message_type :integer          not null
#  metadata     :json             not null
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
  ANALYTIC_TYPES = %w[error preview graph download]

  belongs_to :chat
  has_one_attached :file

  validates :token, :message, :message_type, :metadata, presence: true
  validates :token, uniqueness: true

  enum message_type: {
    user: 0,
    assistant: 1,
    system: 2
  }

  scope :active, -> { where(active: true) }

  def file_url
    file.attached? ? Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) : nil
  end
end
