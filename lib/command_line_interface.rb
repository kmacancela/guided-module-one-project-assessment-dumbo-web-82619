# require 'tty-prompt'
# require 'tty-table'

class CommandLineInterface

    attr_reader :prompt
    attr_accessor :user
    
    def initialize()
        @prompt = TTY::Prompt.new
    end

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
            self.new_post
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

    # Will allow user to create a new post
    def new_post
        puts "INSIDE NEW POST METHOD IN CLI CLASS"
    end

    # Will allow uer to find the post(s) of the book they are searching for
    def find_books
        puts "INSIDE FIND BOOKS METHOD IN CLI CLASS"
    end

end