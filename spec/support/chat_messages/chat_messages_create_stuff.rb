# frozen_string_literal: true

RSpec.shared_context 'chat_messages_create_stuff' do
  let(:chat) { create(:chat) }
  let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/sample.txt'), 'text/plain') }

  before(:each) do
    File.write(Rails.root.join('spec/fixtures/files/sample.txt'), "Sample data for testing\nLine 2\nLine 3")
  end

  after(:each) do
    File.delete(Rails.root.join('spec/fixtures/files/sample.txt')) if File.exist?(Rails.root.join('spec/fixtures/files/sample.txt'))
  end

  let(:valid_attributes) do
    {
      chat_message: {
        chat_id: chat.id,
        message: "Please analyze this data",
        file: file
      }
    }
  end

  let(:valid_attributes_without_file) do
    {
      chat_message: {
        chat_id: chat.id,
        message: "What was the last analysis result?"
      }
    }
  end

  let(:invalid_attributes) do
    {
      chat_message: {
        chat_id: 999999,
        message: "Invalid chat"
      }
    }
  end

  let(:text_response) do
    {
      success: true,
      data: {
        action: "text",
        role: "assistant",
        message: "Here is the analysis of your data...",
        has_file: false,
        extension: nil,
        timestamp: Time.current.strftime("%Y-%m-%d %H:%M:%S")
      }
    }
  end

  let(:preview_response) do
    {
      success: true,
      data: {
        action: "preview",
        role: "assistant",
        message: "Here is a preview of your data...",
        has_file: true,
        extension: "txt",
        source_code: "sample_code",
        timestamp: Time.current.strftime("%Y-%m-%d %H:%M:%S")
      }
    }
  end
end
