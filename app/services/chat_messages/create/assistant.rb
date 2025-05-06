module ChatMessages
  module Create
    class Assistant < Base

      private

      def create_chat
        msg = chat.chat_messages.new(
          token: generate_token,
          message: data[:message],
          message_type: :assistant,
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

        attach_file(msg) if has_file?
        msg.save!
        msg.reload
      end
    end
  end
end
