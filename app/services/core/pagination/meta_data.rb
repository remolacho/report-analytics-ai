module Core
  module Pagination
    class MetaData
      class << self
        def pagination(collection)
          {
              current_page: collection.current_page,
              total_pages: collection.total_pages,
              total_count: collection.total_count,
              next_page: collection.next_page,
              prev_page: collection.prev_page
            }
        end
      end
    end
  end
end

