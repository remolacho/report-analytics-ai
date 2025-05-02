# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::HiController, type: :request do
  path '/v1/hi' do
    get 'Get HI' do
      tags 'Hi'
      consumes 'application/json'

      response '200', 'Hi' do
        before do
          get '/v1/hi'
        end

        describe 'hi' do
          it 'returns http success' do
            expect(response).to have_http_status(:ok)
          end

          it 'JSON body response contains expected recipe attributes' do
            json_response = JSON.parse(response.body)
            expect(json_response['data']).to eq('Welcome to skeleton API Rails')
          end
        end
      end
    end
  end
end