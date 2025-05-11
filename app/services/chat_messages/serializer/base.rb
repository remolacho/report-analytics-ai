module ChatMessages
  module Serializer
    class Base
      def self.parse(action, response, df=nil)
        parse_message(action, response, df)
      end

      private

      def self.parse_message(action, response, df)
        return serialize_message(action, response, df) if df.present?

        response.metadata["response"] ? msg_success(response, action) : msg_error(response, action)
      rescue StandardError => e
        msg_error(response, action, e)
      end

      def self.serialize_message(action, response, df)
        raise NotImplementedError, "Subclasses must implement this method"
      end

      def self.save(response, table)
        response.metadata = response.metadata.merge(response: table)
        response.save!
        response.reload
      end

      def self.msg_success(response, action)
        {
          action: action,
          role: response.metadata["role"],
          message: response.metadata["response"],
          has_file: false,
          extension: nil,
          source_code: response.metadata["source_code"],
          timestamp: response.created_at.strftime("%Y-%m-%d %H:%M:%S")
        }
      end

      def self.msg_error(response, action, e = nil)
        {
          action: "text",
          role: "assistant",
          message: "Los siento, no puedo mostrar la #{action} me ayudas con palabras claves \n,
                    como suma, totalizar, agrupar, filtrar , seleccionar",
          error: e&.message,
          timestamp: response.metadata["timestamp"]
        }
      end
    end
  end
end
