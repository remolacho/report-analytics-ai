module Api
  module V1
    module ChatMessages
      class CreateController < ApplicationController
        # POST /v1/chat_messages
        def create
          result = Analytic::Setup.new(
            chat_message_params[:chat_id],
            chat_message_params[:message],
            chat_message_params[:file]
          ).call

          render json: {
            success: true,
            data: result
          }, status: :created
        end

        private

        def chat_message_params
          @chat_message_params ||= params.require(:chat_message).permit(:chat_id, :message, :file)
        end
      end
    end
  end
end
