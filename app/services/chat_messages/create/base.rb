module ChatMessages
  module Create
    class Base
      attr_reader :chat, :data, :file

      def initialize(chat, data, file=nil)
        @chat = chat
        @data = data
        @file = file
      end

      def perform
        create_chat
      end

      private

      def create_chat
        raise NotImplementedError, 'Subclasses must implement this method'
      end

      def attach_file(msg)
        msg.file.attach(
          io: File.open(file.path),
          filename: File.basename(file.path),
          content_type: content_type
        )
      end

      def content_type
        case extension&.downcase
        when 'xlsx'
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        when 'csv'
          'text/csv'
        when 'json'
          'application/json'
        else
          'application/octet-stream'
        end
      end

      def extension
        return nil unless has_file?

        file.path.split('.').last
      end

      def generate_token
        SecureRandom.uuid
      end

      def has_file?
        @has_file ||= file.present?
      end
    end
  end
end
