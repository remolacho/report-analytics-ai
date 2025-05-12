module Core
  module DataFrame
    class Csv
      class << self

        def create(file)
          Polars.read_csv(file.path)
        end
      end
    end
  end
end
