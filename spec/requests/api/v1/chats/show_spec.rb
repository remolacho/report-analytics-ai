# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::Chats::ShowController, type: :request do
  include_context 'chats_show_stuff'

  path '/v1/chats/show/{id}' do
    get 'Show chat and messages' do
      tags 'Chats'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Chat ID'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number for messages'

      response '200', 'chat found' do
        schema type: :object,
          properties: {
            success: { type: :boolean },
            data: {
              type: :object,
              properties: {
                chat: {
                  type: :object,
                  properties: {
                    id: { type: :integer },
                    reference: { type: :string },
                    token: { type: :string },
                    active: { type: :boolean },
                    created_at: { type: :string, format: 'date-time' },
                    updated_at: { type: :string, format: 'date-time' }
                  }
                },
                messages: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      content: { type: :string },
                      role: { type: :string },
                      created_at: { type: :string, format: 'date-time' },
                      updated_at: { type: :string, format: 'date-time' }
                    }
                  }
                },
                pagination: {
                  type: :object,
                  properties: {
                    current_page: { type: :integer },
                    total_pages: { type: :integer },
                    total_count: { type: :integer },
                    next_page: { type: [:integer, :null] },
                    prev_page: { type: [:integer, :null] }
                  }
                }
              }
            }
          }

        let(:id) { chat.id }

        run_test!

        it 'returns success status' do
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to eq(true)
        end

        it 'returns chat with messages' do
          json_response = JSON.parse(response.body)
          expect(json_response['data']['chat']['id']).to eq(chat.id)
          expect(json_response['data']['messages'].length).to eq(5)
          expect(json_response['data']['pagination']).to be_present
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
