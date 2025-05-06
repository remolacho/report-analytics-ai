module Core
  module Ai
    class Builder
      attr_reader :prompt, :model

      def initialize(prompt, model = "gpt-3.5-turbo")
        @prompt = prompt
        @model = model
      end

      def build
        case model
        when "gpt-3.5-turbo"
          Gpt35Turbo.new(prompt).call
        else
          raise ArgumentError, "Invalid model: #{model}"
        end
      end
    end
  end
end
