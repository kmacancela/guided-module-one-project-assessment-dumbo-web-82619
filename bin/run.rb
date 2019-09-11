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

cli.main_menu

# binding.pry
# 0