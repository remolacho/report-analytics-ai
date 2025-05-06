module ChatMessages
  module Create
    class System < Base
      private

      def create_chat
        msg = chat.chat_messages.new(
          token: generate_token,
          message: data[:message],
          message_type: :system,
          metadata: {
            action: data[:analytic_type],
            message: data[:message],
            role: data[:role],
            has_file: true,
            extension: extension,
            timestamp: Time.current.to_i,
            history_message: data[:history_message],
          }
        )

        attach_file(msg)
        msg.save!
        msg.reload
      end

    # override
      def attach_file(msg)
        msg_history = chat.chat_messages.find_by(token: data[:history_message][:token])
        return unless msg_history.present?

        msg.file.attach(msg_history.file.blob)
      rescue StandardError
        msg_history = chat.chat_messages.last
        return unless msg_history.present?

          msg.file.attach(msg_history.file.blob)
      end
    end
  end
end
