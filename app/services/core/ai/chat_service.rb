module Core
  module Ai
    class ChatService
      MAX_HISTORY = 10

      class << self
        def chat(message, session_id = nil)
          raise ArgumentError, 'Mensaje no puede estar vacío' if message.blank?
          validate_env_variables!

          client = OpenAI::Client.new
          messages = get_chat_history(session_id)

          if messages.empty?
            messages << { role: "system", content: "Eres un analista de datos útil." }
          end

          messages << { role: "user", content: message }

          response = client.chat(
            parameters: {
              model: ENV.fetch("OPENAI_MODEL", "gpt-3.5-turbo"),
              messages: messages,
              temperature: 0.7,
              max_tokens: 1000
            }
          )

          if response["error"].present?
            raise ArgumentError, response["error"]["message"]
          end

          content = response.dig("choices", 0, "message", "content")

          if content.nil?
            raise ArgumentError, "No se pudo obtener una respuesta válida"
          end

          messages << { role: "assistant", content: content }
          session_id = save_chat_history(session_id, messages)

          {
            success: true,
            content: content,
            session_id: session_id,
            history: messages.reject { |m| m[:role] == "system" }
          }
        rescue OpenAI::Error => e
          raise ArgumentError, e.message
        rescue StandardError => e
          raise ArgumentError, e.message
        end

        def clear_chat_history(session_id)
          Rails.cache.delete("chat_history_#{session_id}") if session_id
        end

        private

        def get_chat_history(session_id)
          return [] unless session_id

          Rails.cache.fetch("chat_history_#{session_id}", expires_in: 1.hour) || []
        end

        def save_chat_history(session_id, messages)
          session_id ||= SecureRandom.uuid

          if messages.size > MAX_HISTORY
            messages = [
              messages.first,
              *messages.last(MAX_HISTORY - 1)
            ]
          end

          Rails.cache.write("chat_history_#{session_id}", messages, expires_in: 1.hour)
          session_id
        end

        def validate_env_variables!
          missing_vars = []
          %w[OPENAI_API_KEY OPENAI_MODEL].each do |var|
            missing_vars << var unless ENV[var].present?
          end

          raise ArgumentError, "Faltan variables de entorno: #{missing_vars.join(', ')}" if missing_vars.any?
        end
      end
    end
  end
end
