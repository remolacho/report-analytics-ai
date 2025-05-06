module Api
  module V1
    module Chats
      class ListController < ApplicationController

        # GET /v1/chats/list
        def index
          chats = ::Chats::List.new(page: params[:page])

          render json: {
            success: true,
            data: chats.collection,
            paginate: chats.pagination
          }
        end
      end
    end
  end
end
