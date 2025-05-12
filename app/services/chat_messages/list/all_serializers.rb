module ChatMessages
  module List
    class AllSerializers
      attr_reader :chat, :page

      def initialize(chat_id, page=1)
        @chat = Chat.find(chat_id)
        @page = page
      end

      def get
        collection.reverse.map do |message|
          factory(message.metadata["action"]).parse(message)
        end
      end

      def pagination
        @pagination ||= ::Core::Pagination::MetaData.pagination(collection)
      end

      private

      def factory(action)
        case action
        when 'text'
          ::ChatMessages::Serializer::Text
        when 'preview'
          ::ChatMessages::Serializer::Preview
        when 'graph'
          ::ChatMessages::Serializer::Graph
        else
          ::ChatMessages::Serializer::Text
        end
      end

      def collection
        @collection ||= chat.chat_messages
            .where(message_type: [:user, :assistant])
            .order(created_at: :desc)
            .page(page)
            .per(10)
      end
    end
  end
end
