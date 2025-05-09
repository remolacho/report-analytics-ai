module Analytic
  class Setup
    attr_reader :chat, :message, :file

    def initialize(chat_id, message, file)
      @chat = Chat.find(chat_id)
      @message = message
      @file = file
    end

    def call
      msg = ::ChatMessages::Create::User.new(chat, message, file).perform
      prompt = ::Core::Prompts::Builder.new(msg: msg, chat: chat).build("AnalyticText")
      response = ::Core::Ai::Builder.new(prompt).build

      if response[:action] == "text" || response[:action] == "error"
        msg = ::ChatMessages::Create::Assistant.new(chat, response, msg).perform
        return ::ChatMessages::Serializer::Text.parse(msg)
      end

      msg_system = ::ChatMessages::Create::System.new(chat, response).perform
      temp_file = ::Core::Convert::StreamToTmp.file(msg_system.previous_message.file)
      df = ::Core::DataFrame::Builder.new.build(temp_file)
      ::Analytic::Actions::Builder.build(chat, df, msg_system)
    end
  end
end
