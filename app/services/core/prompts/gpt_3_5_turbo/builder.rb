module Core
  module Prompts
    module Gpt35Turbo
      class Builder
        attr_reader :msg, :df, :chat

        def initialize(msg:, df: nil, chat: nil)
          @msg = msg
          @df = df
          @chat = chat
        end

        def build(prompt_type)
          case prompt_type
          when "AnalyticText"
            ::Core::Prompts::Gpt35Turbo::AnalyticText.new(chat: chat, msg: msg).prompt
          when "ActionsPreview"
            ::Core::Prompts::Gpt35Turbo::ActionsPreview.new(df: df, msg: msg).prompt
          when "ActionsGraph"
            ::Core::Prompts::Gpt35Turbo::ActionsGraph.new(df: df, msg: msg).prompt
          end
        end
      end
    end
  end
end
