class CommandLineInterface

    attr_reader :prompt
    attr_accessor :user, :post
    
    def initialize()
        @prompt = TTY::Prompt.new
    end

    # Will ask user if they are a new or returning user and returns the User object
    def greet
        puts ""
        puts 'Welcome to Student Exchange - The Best Book-Exchanging Application on College Campuses throughout the USA!'
        print " " * "Welcome to ".length
        print "-" * "Student Exchange".length
        print " " * " - The ".length
        print "-" * "Best".length
        print " " * " Book-Exchanging ".length
        puts "-" * "App".length
        choice = self.prompt.select("Are you a new user or returning user?") do |menu|
            menu.choice "New User"
            menu.choice "Returning User"
        end

        # Based on the user's choice, will redirect them to the appropriate User method
        case choice
        when "New User"
            User.handle_new_user
        when "Returning User"
            User.handle_returning_user
        end 
    end

    def main_menu

        choice = self.prompt.select("Hi there, #{self.user.name}! What would you like to do today?") do |menu|
            menu.choice "Create a new post"
            menu.choice "Find a book"
            menu.choice "View or edit my posts"
            menu.choice "Exit"
        end

    end

    def add_book

        name = self.prompt.ask("What is the name of your book: ")
        author = self.prompt.ask("Who is the author of your book: ")
        isbn = self.prompt.ask("What is the ISBN of your book: ")

        book = Book.find_by(isbn: isbn)
        if book == nil
            book = Book.create(name: name, author: author, isbn: isbn)
        end

    end

    def meetup_location

        self.prompt.select("Choose a location where to meet up: ") do |menu|
            menu.choice "Powdermaker Hall"
            menu.choice "I Building"
            menu.choice "Kiely Hall"
            menu.choice "Science Building"
        end

    end

    def make_post

        puts "Let's create a new post! Please provide me with some information: "
        book = self.add_book
        building = self.meetup_location
        location = Location.find_by(building: building)
        content = self.prompt.ask("Provide your potential buyers with a small description (signs of wear, price, special instructions, etc): ")

        new_post = Post.create(user_id: self.user.id, book_id: book.id, content: content, date: "#{Time.now.year}-#{Time.now.month}-#{Time.now.day}", status: 0, location_id: location.id)
        formatted_post = "#{self.user.username} is selling #{book.name} by #{book.author}.  You can find them at #{building}!"

    end

    def post_options

        self.prompt.select("What would you like to do now, #{self.user.name}? ") do |menu|
            menu.choice "Edit this post"
            menu.choice "Delete this post"
            menu.choice "View all my posts"
            menu.choice "Logout"
        end

    end

    # Will allow user to create a new post, find a book post(s), view/edit their posts, or exit to main menu
    def posts

        case choice = self.main_menu
        when "Create a new post"

            new_post = self.make_post
            puts "You posted: #{new_post}"
            choice = self.post_options

            case choice
            when "Edit this post"
                
            when "Delete this post"

            when "View all my posts"

            when "Logout"

            end

        when "Find a book"
            Book.find_book
        when "View or edit my posts"
            self.user.posts.map do |post|
                puts post.content
            end
        when "Exit"
            # add what will happen
            exit
        end
    end



    # Nick is working on the below:
    #     puts ""
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
end