module Core
  module Convert
    class XlsxToDataSet
      class << self
        def data_set(xlsx_file)
          unless xlsx_file.respond_to?(:path) && File.exist?(xlsx_file.path)
            raise ArgumentError, 'Archivo inválido o no existe'
          end

          xlsx = Roo::Spreadsheet.open(xlsx_file.path)
          header = detect_header_row(xlsx)
          raise ArgumentError, 'No se pudo detectar una fila de encabezados válida' unless header[:value].present?

          sheet = xlsx.sheet(0)

          rows = (header[:index] + 1..sheet.last_row).filter_map do |index|
            row = sheet.row(index)
            next if row.length != header[:value].length

            header[:value].zip(row).to_h
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
