require_relative '../config/environment'
require 'pry'

# Starts the application
cli = CommandLineInterface.new
cli.greet

# Prompts user to enter their name
puts "Enter your name to view all your posts:"
users_name = gets.chomp

# Creates a User instance from the user's input
user_object = User.new(name: users_name)

# Returns posts of this User instance
user_object.user_posts

binding.pry
0