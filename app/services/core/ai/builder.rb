module Core
  module Ai
    class Builder
      attr_reader :prompt, :model

      def initialize(prompt, model = Chat::AI_MODEL)
        @prompt = prompt
        @model = model
      end

      def build
        case model
        when Chat::AI_MODEL
          Gpt35Turbo.new(prompt).call
        else
          raise ArgumentError, "Invalid model: #{model}"
        end
      end
    end
  end
end
