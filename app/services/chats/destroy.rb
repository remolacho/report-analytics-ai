module Chats
  class Destroy
    def initialize(chat_id)
      @chat_id = chat_id
    end

    def call
      deactivate_chat
    end

    private

    attr_reader :chat_id

    def deactivate_chat
      chat = Chat.active.find(chat_id)
      chat.update!(active: false)
      chat
    end
  end
end
