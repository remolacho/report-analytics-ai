class Api::V1::HiController < ApplicationController
  skip_before_action :authorized_user

  def index
    render json: {success: true, data: "Welcome to skeleton API Rails"}, status: :ok
  end
end
