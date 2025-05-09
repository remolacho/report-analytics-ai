module Core
  module Prompts
    module Gpt35Turbo
      class ActionsPreview
        attr_reader :df, :msg

        def initialize(df:, msg:)
          @df = df
          @msg = msg
        end

        def prompt
          [
            {
              role: 'system',
              content: prompt_system
            },
            {
              role: 'user',
              content: prompt_user
            }
          ]
        end

        private

        def prompt_user
          <<~PROMPT
            Instrucción: "#{msg.message}"
            DataFrame disponible como 'df'
            Columnas: #{df.columns.join(', ')}
          PROMPT
        end

        def prompt_system
          <<~PROMPT
            Eres un desarrolador Senior Ruby que genera código para análisis de datos usando Ruby, Polars y Vega.

            ACCIONES PERMITIDAS:
            1. preview: mostrar datos (máx 10 filas)
            2. graph: generar gráficos
            3. download: exportar datos

            MÉTODOS DISPONIBLES:
            Polars:
            - Filtrado: select(), filter(), head(), tail()
            - Agregación: groupby().agg(), sum(), mean(), count()
            - Transformación: sort(), unique(), with_column()
            - Exportación: write_csv(), write_json(), write_parquet()

            Vega:
            plot(:x, :y, type: [:bar, :line, :pie, :column])

            Ruby:
            - métodos de String: gsub(), strip(), split(), join()
            - métodos de Array: map(), each(), select(), reject()
            - métodos de Hash: map(), each(), select(), reject()

            Muestra de datos (5 primeras filas):
            #{df.head(5).to_s}

            REGLAS:
            1. Usa solo los métodos listados
            2. No inventes métodos
            3. Código debe ser válido
            4. Respuesta en JSON

            FORMATOS DE RESPUESTA:

            Éxito:
            {
              "action": "#{ChatMessage::ANALYTIC_TYPES.join('|')}",
              "source_code": "código Ruby",
              "role": "assistant",
              "message": "descripción corta"
            }

            Error:
            {
              "action": "error",
              "role": "assistant",
              "message": "razón del error"
            }
          PROMPT
        end
      end
    end
  end
end
