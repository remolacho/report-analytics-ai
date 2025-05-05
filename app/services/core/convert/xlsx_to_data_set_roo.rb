module Core
  module Convert
    class XlsxToDataSetRoo
      class << self
        def data_set(xlsx_file)
          unless xlsx_file.respond_to?(:path) && File.exist?(xlsx_file.path)
            raise ArgumentError, 'Archivo inválido o no existe'
          end

          xlsx = Roo::Spreadsheet.open(xlsx_file.path)
          header = detect_header_row(xlsx)
          raise ArgumentError, 'No se pudo detectar una fila de encabezados válida' unless header[:value].present?

          rows = []

          xlsx.each_row_streaming(offset: header[:index] + 1) do |row|
            columns = row.map(&:value)
            next if columns.length != header[:value].length

            rows << header[:value].zip(columns).to_h
          end

          rows
        rescue => e
          raise ArgumentError, e.message
        end

        private

        def detect_header_row(xlsx)
          index = 0
          header = []
          accumulator = 0

          xlsx.each_row_streaming do |row|
            current_row = row.map(&:value)
            raise ArgumentError, 'No se pudo detectar una fila de encabezados válida' unless current_row.length > 0

            index += 1
            break if index > 10

            if accumulator < current_row.length
              accumulator += current_row.length
              header = { value: current_row, index: index }
            end
          end

          header
        end
      end
    end
  end
end
