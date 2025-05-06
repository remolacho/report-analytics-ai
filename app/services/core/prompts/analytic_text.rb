module Core
  module Prompts
    class AnalyticText
      def initialize(chat, msg)
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
            Eres un asistente de análisis de datos especializado en procesar archivos CSV, XLSX y JSON usando Ruby con Polars y Vega. Tu tarea es determinar si un mensaje requiere análisis de datos y cómo procesarlo.

            REGLAS DE DECISIÓN:

            1. Si el historial está vacío y el mensaje de usuario no tiene contexto de analisis de datos:
               - SIEMPRE responder con action: "text"
               - Solicitar amablemente el archivo para análisis

            2. Si hay historial y el mensaje del usuario indica análisis de datos:
               - Determinar el tipo: graph, preview o download
               - Seleccionar el archivo correcto del historial
               - Generar instrucción técnica precisa

            SELECCIÓN DE ARCHIVO:
            - Si el mensaje menciona "primer" o "inicial" o similar → usar el primer archivo subido
            - Caso contrario → usar el último archivo subido

            TIPOS DE ANÁLISIS:
            - graph: Generar graficas, gráficar los datos, generar barras
            - preview: Exploración, vista previa detalle de datos, tabla de datos, resumen de datos
            - download: Exportación o descarga de datos procesados
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

        chat_message = chat.chat_messages.active
                           .joins("JOIN active_storage_attachments ON active_storage_attachments.record_id = chat_messages.id
                                   AND active_storage_attachments.record_type = 'ChatMessage'")
                           .where(message_type: :user)

        first = chat_message.first

        last = if history_length > 1
          chat_message.last
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
        @history_length ||= chat.chat_messages.active
            .joins("JOIN active_storage_attachments ON active_storage_attachments.record_id = chat_messages.id
                    AND active_storage_attachments.record_type = 'ChatMessage'")
            .count
      end
    end
  end
end
