module Core
  module Ai
    class Gpt35Turbo < Base
      def call
        if response["error"].present?
          return {
            action: "error",
            role: "assistant",
            message: response["error"]["message"]
          }
        end

        content = response.dig("choices", 0, "message", "content")

        if content.nil?
          return {
            action: "error",
            role: "assistant",
            message: "No se pudo obtener una respuesta válida"
          }
        end

        JSON.parse(content).deep_symbolize_keys
      rescue StandardError => e
        {
          action: "error",
          role: "system",
          message: e.to_s
        }
      end

      private

      def client
        @client ||= OpenAI::Client.new
      end

      def response
        @response ||= client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: prompt,
            temperature: 0.7,
            max_tokens: 2000
          }
        )
      end
    end
  end
end
