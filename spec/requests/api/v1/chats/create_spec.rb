# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::Chats::CreateController, type: :request do
  include_context 'chats_create_stuff'

  path '/v1/chats/create' do
    post 'Create chat' do
      tags 'Chats'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :chat, in: :body, schema: {
        type: :object,
        properties: {
          chat: {
            type: :object,
            properties: {
              reference: { type: :string, example: 'REF-123' }
            },
            required: ['reference']
          }
        }
      }

      response '201', 'chat created' do
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

        let(:chat) { valid_attributes }

        run_test!

        it 'returns success status' do
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to eq(true)
        end

        it 'creates a new chat' do
          json_response = JSON.parse(response.body)
          expect(json_response['data']['reference']).to eq(valid_attributes[:chat][:reference])
          expect(json_response['data']['token']).to be_present
          expect(json_response['data']['active']).to eq(true)
        end
      end

      response '422', 'invalid request' do
        schema type: :object,
          properties: {
            success: { type: :boolean },
            message: { type: :string }
          }

        let(:chat) { invalid_attributes }

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
