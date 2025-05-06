module Chats
  class Show
    attr_reader :chat_id, :page

    def initialize(chat_id, page = 1)
      @chat_id = chat_id
      @page = page
    end

    def chat
      @chat ||= Chat.find(chat_id)
    end

    def messages
      @messages ||= chat.chat_messages
                        .order(created_at: :desc)
                        .page(page)
                        .per(10)
    end

    def pagination
      ::Core::Pagination::MetaData.pagination(messages)
    end
  end
end
