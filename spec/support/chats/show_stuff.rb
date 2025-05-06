# frozen_string_literal: true

shared_context 'chats_show_stuff' do
  let!(:chat) { FactoryBot.create(:chat) }

  let!(:chat_messages) do
    FactoryBot.create_list(:chat_message, 5, chat: chat)
  end
end
