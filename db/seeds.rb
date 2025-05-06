# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# This file should contain all the record creation needed to seed the database
require 'ffaker'

puts 'Creating dummy chats and messages...'

# Create active chats
5.times do |i|
  chat = Chat.create!(
    reference: "CHAT-#{i+1}",
    token: SecureRandom.uuid,
    active: true
  )

  # Create messages for each chat
  10.times do |j|
    ChatMessage.create!(
      chat: chat,
      token: SecureRandom.uuid,
      message: FFaker::Lorem.sentence,
      message_type: j.even? ? 0 : 1,
      response: j.even? ? nil : FFaker::Lorem.paragraph,
      metadata: {
        timestamp: Time.current.to_i,
        role: j.even? ? 'user' : 'assistant',
        tokens: rand(50..200)
      },
      active: true
    )
  end
end

puts "Created #{Chat.count} chats with #{ChatMessage.count} messages"
