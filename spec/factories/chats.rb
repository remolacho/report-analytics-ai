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
FactoryBot.define do
  factory :chat do
    
  end
end
