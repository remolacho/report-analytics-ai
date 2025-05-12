module Core
  module Ai
    class Base
      attr_reader :prompt
      def initialize(prompt)
        @prompt = prompt
      end

      def call
         raise NotImplementedError, 'Subclasses must implement the call method'
      end

      private

      def client
        raise NotImplementedError, 'Subclasses must implement the client method'
      end

      def response
        raise NotImplementedError, 'Subclasses must implement the response method'
      end
    end
  end
end
