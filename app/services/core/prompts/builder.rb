module Core
  module Prompts
    class Builder
      attr_reader :msg, :df, :chat, :model

      def initialize(msg:, df: nil, chat: nil, model: Chat::AI_MODEL)
        @msg = msg
        @df = df
        @chat = chat
        @model = model
      end

      def build(prompt_type)
        raise "Invalid model: #{model}" unless model.eql?(Chat::AI_MODEL)

        ::Core::Prompts::Gpt35Turbo::Builder.new(msg: msg, df: df, chat: chat)
                                            .build(prompt_type)
      end
    end
  end
end
