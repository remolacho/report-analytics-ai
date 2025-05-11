module Core
  module Prompts
    module Gpt35Turbo
      class AnalyticText
        def initialize(chat:, msg:)
          @chat = chat
          @msg = msg
        end

        attr_reader :chat, :msg

        def prompt
          [
            system_message,
            user_message_with_context
          ]
        end

        private

        def system_message
          {
            role: 'system',
            content: <<~PROMPT
              Eres un asistente de análisis de datos especializado en detectar que TIPOS DE ANÁLISIS solicita el usuario.

              TIPOS DE ANÁLISIS:
              - graph: Generar graficas, gráficar los datos, generar barras, pie, columnas, etc.
              - preview: Exploración, vista previa, detalle de datos, tabla de datos, resumen de datos

              REGLAS DE DECISIÓN:

              1. Si el usuario envia "Sin historial = SI" o el mensaje de usuario no tiene contexto de analisis de datos:
                - SIEMPRE responder con action: "text"
                - Solicitar amablemente mas informacion para análisis

              2. Si el usuario envia "Sin historial = NO" y el mensaje del usuario indica análisis de datos:
                - Determinar el tipo: graph, preview
                - Seleccionar el archivo correcto del historial
                - Generar instrucción técnica precisa

              SELECCIÓN DE ARCHIVO:
              - Si el mensaje menciona "primer" o "inicial" o similar → usar el primer archivo subido
              - Caso contrario → usar el último archivo subido
            PROMPT
          }
        end

        def user_message_with_context
          {
            role: 'user',
            content: <<~PROMPT
              CONTEXTO:
              Sin historial: #{histories.empty? ? 'SI' : 'NO'}
              Historial: #{histories.to_json}
              Mensaje: "#{msg.message}"

              RESPONDER EN UNO DE ESTOS FORMATOS:

              Sin historial:
              {
                "action": "text",
                "role": "assistant",
                "message": RESPONDER MENSAJE CORTO Y AGRADABLE, SOLICITANDO ARCHIVO
              }

              Con historial y análisis:
              {
                "action": "analytic",
                "role": "system",
                "history_message": { SIEMPRE FORMATO JSON -> historia_seleccionada},
                "message": #{msg.message}
                "analytic_type": "graph|preview|download"
              }
            PROMPT
          }
        end

        def histories
          @histories ||= resume_histories
        end

        def resume_histories
          if history_length.zero?
            return []
          end

          first = query_history.first

          last = if history_length > 1
            query_history.last
          end

          [first, last].compact.map.with_index do |message, index|
            {
              index: index,
              token: message.token,
              message: message.message
            }
          end
        end

        def history_length
          @history_length ||= query_history.count
        end

        def query_history
          @query_history ||= chat.chat_messages.active
              .joins("JOIN active_storage_attachments ON active_storage_attachments.record_id = chat_messages.id
                      AND active_storage_attachments.record_type = 'ChatMessage'")
              .where(message_type: :user)
        end
      end
    end
  end
end
