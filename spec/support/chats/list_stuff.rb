# frozen_string_literal: true

shared_context 'chats_list_stuff' do
  let!(:chats) do
    FactoryBot.create_list(:chat, 5)
  end

  let!(:inactive_chat) do
    FactoryBot.create(:chat, active: false)
  end
end
