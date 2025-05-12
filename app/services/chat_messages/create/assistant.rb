module ChatMessages
  module Create
    class Assistant < Base
      attr_reader :previous_message

      def initialize(chat, data, previous_message=nil)
        super(chat, data)

        @previous_message = previous_message
      end

      private

      def create_chat
        msg = chat.chat_messages.new(
          token: generate_token,
          message: data[:message],
          message_type: :assistant,
          previous_message_id: previous_message&.id,
          metadata: {
            action: data[:action],
            message: data[:message],
            role: data[:role],
            source_code: data[:source_code],
            has_file: has_file?,
            extension: extension,
            timestamp: Time.current.to_i
          }
        )

        msg.save!
        msg.reload
      end
    end
  end
end
