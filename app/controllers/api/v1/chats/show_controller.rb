module Api
  module V1
    module Chats
      class ShowController < ApplicationController
        # GET /v1/chats/:id
        def show
          service = ::ChatMessages::List::AllSerializers.new(params[:id], params[:page])

          render json: {
            success: true,
            data: {
              chat: service.chat,
              messages: service.get,
              pagination: service.pagination
            }
          }
        end
      end
    end
  end
end
