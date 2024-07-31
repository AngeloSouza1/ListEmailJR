# db/seeds.rb

# Certifique-se de que a gem Devise está instalada e configurada corretamente.

puts "Creating a default user..."

User.create!(
  email: 'user@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

puts "User created with email: 'user@example.com' and password: 'password123'"
