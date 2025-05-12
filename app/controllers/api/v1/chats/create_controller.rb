module Api
  module V1
    module Chats
      class CreateController < ApplicationController
        # POST /v1/chats
        def create
          chat = ::Chats::Create.new(chat_params)

          render json: {
            success: true,
            data: chat.call
          }, status: :created
        end

        private

        def chat_params
          params.require(:chat).permit(:reference)
        end
      end
    end
  end
end
