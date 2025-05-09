# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Chat Messages API', type: :request do
  include_context 'chat_messages_create_stuff'

  path '/v1/chat_messages/create' do
    post 'Creates a chat message' do
      tags 'Chat Messages'
      description 'Creates a new chat message with optional file analysis. The message can be a simple text query or include a file for analysis.'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: 'chat_message[chat_id]', in: :formData, type: :integer, required: true
      parameter name: 'chat_message[message]', in: :formData, type: :string, required: true
      parameter name: 'chat_message[file]', in: :formData, type: :file, required: false

      response '201', 'chat message created' do
        schema type: :object,
          properties: {
            success: { type: :boolean },
            data: {
              type: :object,
              properties: {
                action: { type: :string, enum: ['text', 'preview', 'graph', 'download'] },
                role: { type: :string, enum: ['assistant', 'user', 'system'] },
                message: { type: :string },
                has_file: { type: :boolean },
                extension: { type: [:string, :null] },
                source_code: { type: [:string, :null] },
                timestamp: { type: :string }
              }
            }
          }

        context 'when sending a text message' do
          let(:'chat_message[chat_id]') { valid_attributes_without_file[:chat_message][:chat_id] }
          let(:'chat_message[message]') { valid_attributes_without_file[:chat_message][:message] }

          run_test! do
            data = JSON.parse(response.body)
            expect(data['success']).to eq(true)
            expect(data['data']['action']).to eq('text')
            expect(data['data']['has_file']).to eq(false)
          end
        end

        context 'when sending a message with file' do
          let(:'chat_message[chat_id]') { valid_attributes[:chat_message][:chat_id] }
          let(:'chat_message[message]') { valid_attributes[:chat_message][:message] }
          let(:'chat_message[file]') { valid_attributes[:chat_message][:file] }

          before do
            allow_any_instance_of(Analytic::Setup).to receive(:call).and_return({
              action: 'preview',
              role: 'assistant',
              message: 'Analysis completed',
              has_file: true,
              extension: 'txt',
              source_code: nil,
              timestamp: Time.current.strftime('%Y-%m-%d %H:%M:%S')
            })
          end

          run_test! do
            data = JSON.parse(response.body)
            expect(data['success']).to eq(true)
            expect(data['data']['has_file']).to eq(true)
            expect(data['data']['action']).to eq('preview')
          end
        end
      end

      response '404', 'chat not found' do
        schema type: :object,
          properties: {
            success: { type: :boolean, example: false },
            message: { type: :string },
            object: { type: :string },
            id: { type: [:string, :integer, :null] }
          }

        let(:'chat_message[chat_id]') { invalid_attributes[:chat_message][:chat_id] }
        let(:'chat_message[message]') { invalid_attributes[:chat_message][:message] }

        run_test! do
          data = JSON.parse(response.body)
          expect(data['success']).to eq(false)
          expect(data['message']).to eq("Couldn't find Chat with 'id'=999999")
        end
      end

      response '404', 'invalid request' do
        schema type: :object,
          properties: {
            success: { type: :boolean, example: false },
            message: { type: :string },
            object: { type: :string },
            id: { type: [:string, :integer, :null] }
          }

        let(:'chat_message[message]') { missing_chat_id_attributes[:chat_message][:message] }
        let(:'chat_message[chat_id]') { nil }

        run_test! do
          data = JSON.parse(response.body)
          expect(data['success']).to eq(false)
          expect(data['message']).to eq("Couldn't find Chat with 'id'=")
        end
      end
    end
  end
end
