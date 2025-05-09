module ChatMessages
  module Serializer
    class Graph
      def self.parse(response, df=nil)
        {
          action: "graph",
          role: response.metadata["role"],
          message: parse_message(response, df),
          has_file: false,
          extension: nil,
          source_code: response.metadata["source_code"],
          timestamp: response.created_at.strftime("%Y-%m-%d %H:%M:%S")
        }
      end

      private

      def self.parse_message(response, df)
        return create_json(response, df) if df.present?

        response.metadata["response"]
      rescue StandardError => e
        {
          action: "text",
          role: "assistant",
          message: "<div>Los siento, no puedo mostrar el grafico me ayudas con palabras claves \n,
                    como suma, totalizar, agrupar, filtrar , seleccionar</div>",
          error: e.message,
          timestamp: Time.current.to_i
        }
      end

      def self.create_json(response, df)
        result = eval(response.metadata["source_code"], binding)
        response.update(metadata: response.metadata.merge(response: result))
        result.to_json
      end
    end
  end
end
