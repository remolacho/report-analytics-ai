module ChatMessages
  module Create
    class System < Base
      private

      def create_chat
        msg = chat.chat_messages.new(
          token: generate_token,
          message: data[:message],
          message_type: :system,
          previous_message_id: previous_message&.id,
          metadata: {
            action: data[:analytic_type],
            message: data[:message],
            role: data[:role],
            has_file: true,
            extension: extension,
            timestamp: Time.current.to_i
          }
        )

        msg.save!
        msg.reload
      end

      def previous_message
        @previous_message ||= chat.chat_messages.find_by(token: data[:history_message][:token])
      rescue StandardError
        @rpevious_message ||= chat.chat_messages.active
        .joins("JOIN active_storage_attachments ON active_storage_attachments.record_id = chat_messages.id
                AND active_storage_attachments.record_type = 'ChatMessage'")
        .where(message_type: :user)
        .last
      end
    end
  end
end
