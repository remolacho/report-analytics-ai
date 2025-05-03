class Api::V1::HiController < ApplicationController
  def index
    render json: {success: true, data: "Welcome to skeleton API Rails"}, status: :ok
  end
end
