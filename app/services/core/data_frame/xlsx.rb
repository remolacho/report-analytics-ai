module Core
  module DataFrame
    class Xlsx
      class << self

        def create(file)
          Polars::DataFrame.new(xlsx_to_data_set(file))
        end

        private

        def xlsx_to_data_set(file)
          ::Core::Convert::XlsxToDataSetCreek.data_set(file)
        end
      end
    end
  end
end
