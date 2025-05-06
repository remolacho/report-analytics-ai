module ChatMessages
  module Serializer
    class Text
      def self.parse(response)
        file = response.file

        {
          action: "text",
          role: response.metadata["role"],
          message: response.metadata["message"],
          has_file: file.attached?,
          filename: file.attached? ? file.filename.to_s : nil,
          extension: file.attached? ? file.filename.extension : nil,
          timestamp: response.created_at.strftime("%Y-%m-%d %H:%M:%S")
        }
      end
    end
  end
end
