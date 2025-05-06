module Analytic
  module Actions
    class Preview
      attr_reader :chat, :df, :msg_system

      def initialize(chat, df, msg_system)
        @chat = chat
        @df = df
        @msg_system = msg_system
      end

      def build
        prompt = ::Core::Prompts::ActionsPreview.new(df, msg_system).prompt
        response = ::Core::Ai::Builder.new(prompt).build
        msg_assistant = ::ChatMessages::Create::Assistant.new(chat, response).perform

        return ::ChatMessages::Serializer::Text.parse(msg_assistant) if  response[:action] == "error"

        ::ChatMessages::Serializer::Preview.parse(msg_assistant, df)
      end
    end
  end
end
