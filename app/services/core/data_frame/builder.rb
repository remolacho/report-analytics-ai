module Core
  module DataFrame
    class Builder
      def build(file)
        extension = file.path.split('.').last

        case extension
        when 'xlsx'
          ::Core::DataFrame::Xlsx.create(file)
        when 'csv'
          ::Core::DataFrame::Csv.create(file)
        when 'json'
          ::Core::DataFrame::Json.create(file)
        else
          raise "Unsupported file type: #{extension}"
        end
      end
    end
  end
end
