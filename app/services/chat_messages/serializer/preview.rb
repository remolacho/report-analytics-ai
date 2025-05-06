module ChatMessages
  module Serializer
    class Preview
      def self.parse(response, df=nil)
        {
          action: "preview",
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
        return create_html(response, df) if df.present?

        response.metadata["response"]
      rescue StandardError => e
        {
          action: "text",
          role: "assistant",
          message: "Los siento, no puedo mostrar el preview me ayudas con palabras claves \n,
                    como suma, totalizar, agrupar, filtrar , seleccionar",
          error: e.message,
          timestamp: Time.current.to_i
        }
      end

      def self.create_html(response, df)
        eval(response.metadata["source_code"], binding)
        result = eval(response.metadata["source_code"], binding)

        result = <<~HTML.gsub(/\s+/, ' ').strip
          <table>
            <thead>
              <tr>
                #{result.columns.map { |col| "<th>#{col}</th>" }.join}
              </tr>
            </thead>
            <tbody>
              #{result.rows.map { |row|
                "<tr>#{row.map { |val| "<td>#{val}</td>" }.join}</tr>"
              }.join}
            </tbody>
          </table>
        HTML

        response.update(metadata: response.metadata.merge(response: result))
        result
      end
    end
  end
end
