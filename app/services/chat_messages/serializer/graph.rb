module ChatMessages
  module Serializer
    class Graph < Base
      def self.parse(response, df=nil)
        super("graph", response, df)
      end

      private

      # override
      def self.serialize_message(action, response, df)
        result = eval(response.metadata["source_code"], binding)
        msg_success(save(response, result), action)
      end
    end
  end
end
