module Api
  module V1
    module Core
      class ChatController < ApplicationController
        # POST /v1/core/chat
        def create
          data = ::Core::Ai::ChatService.chat(chat_params[:message], chat_params[:session_id])

          render json: {
            success: true,
            message: data[:content],
            session_id: data[:session_id],
            history: data[:history]
          }
        end

        # DELETE /v1/core/chat/:session_id
        def destroy
          ::Core::Ai::ChatService.clear_chat_history(params[:session_id])
          head :no_content
        end

        private

        def chat_params
          params.permit(:message, :session_id)
        end
      end
    end
  end
end
