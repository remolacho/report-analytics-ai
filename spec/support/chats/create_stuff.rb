# frozen_string_literal: true

shared_context 'chats_create_stuff' do
  let(:valid_attributes) do
    {
      chat: {
        reference: "REF-#{FFaker::Lorem.word}"
      }
    }
  end

  let(:invalid_attributes) do
    {
      chat: {
        reference: nil
      }
    }
  end
end
