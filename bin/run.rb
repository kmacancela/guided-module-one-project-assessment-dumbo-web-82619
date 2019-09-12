require_relative '../config/environment'

# Starts the application by creating a CLI instance and calling the greet method
cli = CommandLineInterface.new
current_user = cli.greet

# Keeps asking user if they are a new or returning user until user object is created
while current_user == nil
    current_user = cli.greet
end