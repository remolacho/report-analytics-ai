module Api
  module V1
    module Chats
      class ShowController < ApplicationController
        # GET /v1/chats/:id
        def show
          service = ::Chats::Show.new(params[:id], params[:page])

          render json: {
            success: true,
            data: {
              chat: service.chat,
              messages: service.messages,
              pagination: service.pagination
            }
          }
        end
      end
    end
  end
end
