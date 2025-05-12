module ChatMessages
  module Create
    class User < Base

      private

      def create_chat
      msg = chat.chat_messages.new(
        token: generate_token,
        message: data,
        message_type: :user,
        metadata: {
          action: 'text',
          message: data,
          role: 'user',
          has_file: has_file?,
          extension: extension,
          source_code: nil,
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
