module Core
  module Ai
    class ChatService
      MAX_HISTORY = 10
      CACHE_KEY_PREFIX = "chat_history"
      CACHE_EXPIRY = 1.minute

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
        rescue Redis::BaseError => e
          retry_with_memory_store(message, session_id)
        rescue StandardError => e
          raise ArgumentError, e.message
        end

        def clear_chat_history(session_id)
          return unless session_id

          Rails.cache.delete(cache_key(session_id))
        rescue Redis::BaseError => e
          Rails.logger.error("Failed to clear chat history: #{e.message}")
          false
        end

        private

        def get_chat_history(session_id)
          return [] unless session_id

          Rails.cache.fetch(cache_key(session_id), expires_in: CACHE_EXPIRY) || []
        rescue Redis::BaseError => e
          Rails.logger.error("Failed to get chat history: #{e.message}")
          []
        end

        def save_chat_history(session_id, messages)
          session_id ||= SecureRandom.uuid

          if messages.size > MAX_HISTORY
            messages = [
              messages.first,
              *messages.last(MAX_HISTORY - 1)
            ]
          end

          Rails.cache.write(
            cache_key(session_id),
            messages,
            expires_in: CACHE_EXPIRY,
            race_condition_ttl: 30.seconds
          )
          session_id
        rescue Redis::BaseError => e
          Rails.logger.error("Failed to save chat history: #{e.message}")
          session_id
        end

        def cache_key(session_id)
          "#{CACHE_KEY_PREFIX}_#{session_id}"
        end

        def retry_with_memory_store(message, session_id)
          memory_store = ActiveSupport::Cache::MemoryStore.new
          original_cache = Rails.cache
          begin
            Rails.cache = memory_store
            chat(message, session_id)
          ensure
            Rails.cache = original_cache
          end
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
