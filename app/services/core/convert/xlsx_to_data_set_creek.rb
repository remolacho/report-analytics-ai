module Core
  module Convert
    class XlsxToDataSetCreek
      class << self
        def data_set(xlsx_file)
          unless xlsx_file.respond_to?(:path) && File.exist?(xlsx_file.path)
            raise ArgumentError, 'Archivo inválido o no existe'
          end

          creek = Creek::Book.new(xlsx_file.path)
          sheet = creek.sheets[0]

          header = detect_header(sheet)
          raise ArgumentError, 'No se pudo detectar una fila de encabezados válida' unless header[:value].present?

          process_rows(sheet, header[:value], header[:index])
        rescue Creek::Error => e
          raise ArgumentError, "Error al procesar archivo Excel: #{e.message}"
        rescue StandardError => e
          raise ArgumentError, e.message
        ensure
          creek&.close if defined?(creek) && creek.respond_to?(:close)
        end

        private

        def detect_header(sheet)
          index = 0
          header = { value: [], index: 0 }
          max_columns = 0

          sheet.rows.each do |row|
            index += 1
            break if index > 10

            row_values = row.values
            next if row_values.compact.empty?

            if row_values.length > max_columns
              max_columns = row_values.length
              header = { value: row_values, index: index }
            end
          end

          header
        end

        def process_rows(sheet, headers, header_index)
          rows = []
          current_row = 0

          sheet.rows.each do |row|
            current_row += 1
            next if current_row <= header_index

            row_values = row.values
            next if row_values.length != headers.length || row_values.compact.empty?

            rows << headers.zip(row_values).to_h
          end

          rows
        end
      end
    end
  end
end
