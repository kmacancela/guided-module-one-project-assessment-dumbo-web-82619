class CommandLineInterface

    attr_reader :prompt
    attr_accessor :user

    def initialize
        @prompt = TTY::Prompt.new
    end 

    def program
        puts ""
        puts 'Welcome to Student Exchange - The Best Book-Exchanging Application on College Campuses throughout the USA!'
        print " " * "Welcome to ".length
        print "-" * "Student Exchange".length
        print " " * " - The ".length
        print "-" * "Best".length
        print " " * " Book-Exchanging ".length
        puts "-" * "App".length
        choice = self.prompt.select("Sign Up / Sign In") do |menu|
            puts "_" * "Sign Up / Sign In".length
            menu.choice "New User"
            menu.choice "Returning User"
        end
        case choice
        when "New User"
            User.new_user
        when "Returning User"
            User.existing_user
        end
        puts "Enter your name to view all your posts:"
        name = gets.chomp
    end

end