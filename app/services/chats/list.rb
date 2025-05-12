module Chats
  class List
    attr_reader :page
    def initialize(page: 1)
      @page = page
    end

    def collection
      chats
    end

    def pagination
      @pagination ||= ::Core::Pagination::MetaData.pagination(chats)
    end

    private

    def chats
      @chats ||= Chat.active
                  .order(created_at: :desc)
                  .page(page)
                  .per(10)
    end
  end
end
