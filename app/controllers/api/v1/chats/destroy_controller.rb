module Api
  module V1
    module Chats
      class DestroyController < ApplicationController
        # DELETE /v1/chats/:id
        def destroy
          chat = ::Chats::Destroy.new(params[:id]).call

          render json: {
            success: true,
            data: chat
          }
        end
      end
    end
  end
end
