module Core
  module DataFrame
    class Json
      class << self

        def create(file)
          Polars::DataFrame.read_json(file.path)
        end
      end
    end
  end
end
