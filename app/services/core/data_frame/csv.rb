module Core
  module DataFrame
    class Csv
      class << self

        def create(file)
          Polars::DataFrame.read_csv(file.path)
        end
      end
    end
  end
end
