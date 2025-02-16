# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data (optional, only enable if needed)
# User.destroy_all
# Role.destroy_all
# Article.destroy_all

puts "Seeding data..."

# Create Roles
admin_role = Role.find_or_create_by!(title: "Admin", description: "Administrator role")
editor_role = Role.find_or_create_by!(title: "Editor", description: "Editor role")

puts "Roles created."

# Create Users
admin_user = User.create!(
  email: "hs.shafiei@gmail.com",
  password: 'salam64511',
  password_confirmation: 'salam64511',
  current_role_id: admin_role.id
)


puts "Users created."

# Assign Users to Roles
Assignment.find_or_create_by!(user_id: admin_user.id, role_id: admin_role.id)
Assignment.find_or_create_by!(user_id: admin_user.id, role_id: editor_role.id)

puts "Assignments created."

# Create Example Articles
Article.find_or_create_by!(
  title: "First Article",
  abstract: "This is the first article.",
  content: "Lorem ipsum dolor sit amet...",
  user_id: admin_user.id
)

Article.find_or_create_by!(
  title: "Second Article",
  abstract: "This is the second article.",
  content: "Content for the second article...",
  user_id: editor_user.id
)

puts "Articles created."

puts "Seeding completed successfully!"