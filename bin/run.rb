require_relative '../config/environment'

# Starts the application by creating a CLI instance and calling the greet method
cli = CommandLineInterface.new
current_user = cli.greet

# Keeps asking user if they are a new or returning user until user object is created
while current_user == nil
    current_user = cli.greet
end

# We set the user instance object in CLI class to the user object we created (new user) or retrieved (returning user)
cli.user = current_user

cli.posts


# cli.ask_name

# # Prompts user to enter their name
# puts "Enter your name to view all your posts:"
# users_name = gets.chomp

# # Creates a User instance from the user's input
# user_object = User.new(name: users_name)

# # Returns posts of this User instance
# user_object.user_posts

binding.pry
0