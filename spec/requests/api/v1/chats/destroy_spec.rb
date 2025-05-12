# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::Chats::DestroyController, type: :request do
  include_context 'chats_create_stuff'

  let!(:chat) { FactoryBot.create(:chat) }

  path '/v1/chats/destroy/{id}' do
    delete 'Deactivate chat' do
      tags 'Chats'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Chat ID'

      response '200', 'chat deactivated' do
        schema type: :object,
          properties: {
            success: { type: :boolean },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                reference: { type: :string },
                token: { type: :string },
                active: { type: :boolean },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' }
              }
            }
          }

        let(:id) { chat.id }

        run_test!

        it 'returns success status' do
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to eq(true)
        end

        it 'deactivates the chat' do
          json_response = JSON.parse(response.body)
          expect(json_response['data']['active']).to eq(false)
        end
      end

      response '404', 'chat not found' do
        schema type: :object,
          properties: {
            success: { type: :boolean },
            message: { type: :string }
          }

        let(:id) { 'invalid' }

        run_test!

        it 'returns error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to eq(false)
          expect(json_response['message']).to be_present
        end
      end
    end
  end
end
