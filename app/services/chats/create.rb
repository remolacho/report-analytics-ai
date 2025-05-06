module Chats
  class Create
    def initialize(params)
      @params = params
    end

    def call
      create_chat
    end

    private

    attr_reader :params

    def create_chat
      Chat.create!(
        reference: params[:reference],
        token: generate_token
      )
    end

    def generate_token
      SecureRandom.uuid
    end
  end
end
