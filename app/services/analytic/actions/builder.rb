module Analytic
  module Actions
    class Builder
      def self.build(chat, df, msg_system)
        if msg_system.metadata["action"] == "preview"
          return ::Analytic::Actions::Preview.new(chat, df, msg_system).build
        end

        {
          action: "text",
          role: "assistant",
          message: "Lo siento, no puedo realizar esta acción, dame mas contexto",
          metadata: msg_system.metadata,
          error: "Action not found"
        }
      end
    end
  end
end
