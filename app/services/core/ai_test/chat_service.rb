module Core
  module AiTest
    class ChatService
      MAX_HISTORY = 10

      class << self
        def chat(message, session_id = nil)
          raise ArgumentError, 'Mensaje no puede estar vacío' if message.blank?
          validate_env_variables!

          client = OpenAI::Client.new
          chat = find_or_create_chat(session_id)
          messages = get_chat_history(chat)

          if messages.empty?
            system_message = { role: "system", content: "Eres un analista de datos útil." }
            create_chat_message(chat, system_message)
            messages << system_message
          end

          user_message = { role: "user", content: message }
          create_chat_message(chat, user_message)
          messages << user_message

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

          assistant_message = { role: "assistant", content: content }
          create_chat_message(chat, assistant_message)
          messages << assistant_message

          {
            success: true,
            content: content,
            session_id: chat.token,
            history: messages.reject { |m| m[:role] == "system" }
          }
        rescue OpenAI::Error => e
          raise ArgumentError, e.message
        rescue StandardError => e
          raise ArgumentError, e.message
        end

        def clear_chat_history(session_id)
          return unless session_id

          chat = Chat.find_by(token: session_id)
          chat&.chat_messages&.destroy_all
        end

        private

        def find_or_create_chat(session_id)
          if session_id
            Chat.find_by(token: session_id) || create_chat(session_id)
          else
            create_chat
          end
        end

        def create_chat(token = nil)
          Chat.create!(
            token: token || SecureRandom.uuid,
            reference: "Chat #{Time.current}"
          )
        end

        def get_chat_history(chat)
          messages = chat.chat_messages.order(:created_at).limit(MAX_HISTORY).map do |msg|
            {
              role: msg.metadata["sender"] == "user" ? "user" : "assistant",
              content: msg.message
            }
          end

          messages.presence || []
        end

        def create_chat_message(chat, message)
          sender = case message[:role]
                  when "user" then "user"
                  when "assistant" then "assistant"
                  when "system" then "system"
                  end

          chat.chat_messages.create!(
            token: SecureRandom.uuid,
            message: message[:content],
            response: message[:content],
            message_type: sender == "user" ? :user : :assistant,
            metadata: {
              type: "text",
              text: message[:content],
              sender: sender,
              timestamp: Time.current.to_i
            }
          )
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
