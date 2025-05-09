module Analytic
  module Actions
    class Graph
      attr_reader :chat, :df, :msg_system

      def initialize(chat, df, msg_system)
        @chat = chat
        @df = df
        @msg_system = msg_system
      end

      def build
        prompt = ::Core::Prompts::Builder.new(msg: msg_system, df: df).build("ActionsGraph")
        response = ::Core::Ai::Builder.new(prompt).build

        msg_assistant = ::ChatMessages::Create::Assistant.new(chat,
                                                              response,
                                                              msg_system.previous_message).perform

        return ::ChatMessages::Serializer::Text.parse(msg_assistant) if  response[:action] == "error"

        ::ChatMessages::Serializer::Graph.parse(msg_assistant, df)
      end
    end
  end
end
