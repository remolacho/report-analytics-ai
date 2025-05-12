# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::Chats::ListController, type: :request do
  include_context 'chats_list_stuff'

  path '/v1/chats/list' do
    get 'List chats' do
      tags 'Chats'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number'

      response '200', 'chats found' do
        schema type: :object,
          properties: {
            success: { type: :boolean },
            data: {
              type: :array,
              items: {
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
            },
            paginate: {
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

        let(:page) { 1 }

        run_test!

        it 'returns success status' do
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to eq(true)
        end

        it 'returns only active chats' do
          json_response = JSON.parse(response.body)
          expect(json_response['data'].length).to eq(5)
          expect(json_response['data'].all? { |chat| chat['active'] }).to be true
        end

        it 'returns pagination information' do
          json_response = JSON.parse(response.body)
          expect(json_response['paginate']).to include(
            'current_page',
            'total_pages',
            'total_count',
            'next_page',
            'prev_page'
          )
        end
      end
    end
  end
end
