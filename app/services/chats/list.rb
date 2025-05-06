module Chats
  class List
    def initialize(page: 1)
      @page = page
    end

    def collection
      chats
    end

    def pagination
      ::Core::Pagination::MetaData.pagination(chats)
    end

    private

    def chats
      @chats ||= Chat.active
                  .order(created_at: :desc)
                  .page(@page)
                  .per(10)
    end
  end
end
