# require 'tty-prompt'
# require 'tty-table'

class CommandLineInterface

    attr_reader :prompt
    attr_accessor :user, :post
    
    def initialize()
        @prompt = TTY::Prompt.new
    end
    # puts ""
    #     puts 'Welcome to Student Exchange - The Best Book-Exchanging Application on College Campuses throughout the USA!'
    #     print " " * "Welcome to ".length
    #     print "-" * "Student Exchange".length
    #     print " " * " - The ".length
    #     print "-" * "Best".length
    #     print " " * " Book-Exchanging ".length
    #     puts "-" * "App".length
    #     choice = self.prompt.select("Sign Up / Sign In") do |menu|
    #         puts "_" * "Sign Up / Sign In".length
    #         menu.choice "New User"
    #         menu.choice "Returning User"
    #     end
    #     case choice
    #     when "New User"
    #         User.new_user
    #     when "Returning User"
    #         User.existing_user
    #     end
    #     puts "Enter your name to view all your posts:"
    #     name = gets.chomp


    # Will ask user if they are a new or returning user and returns the user object
    def greet
        puts 'Welcome to Student Exchange, the best book exchanging application on campuses throughout USA!'

        # Using TTY Prompt, will let user select if they are a new or returning user
        choice = self.prompt.select("Are you a new user or returning user?") do |menu|
            menu.choice "New User"
            menu.choice "Returning User"
        end

        # Based on the user's choice, will redirect them to the appropriate method
        case choice
        when "New User"
            User.handle_new_user
        when "Returning User"
            User.handle_returning_user
        end 
    end

    # Will allow user to create a new post, find a book post(s), view/edit their posts, or exit to main menu
    def posts
        choice = self.prompt.select("What would you like to do today?") do |menu|
            menu.choice "Create a new post"
            menu.choice "Find a book"
            menu.choice "View or edit my posts"
            menu.choice "Exit"
        end

        case choice
        when "Create a new post"
            puts "Let's create a new post! Please provide me with some information: "
            Post.new_post
        when "Find a book"
            # add what will happen
        when "View or edit my posts"
            self.user.posts.map do |post|
                puts post.content
            end
        when "Exit"
            # add what will happen
        end
    end

    # Will allow uer to find the post(s) of the book they are searching for
    def find_books
        puts "INSIDE FIND BOOKS METHOD IN CLI CLASS"
    end

end