class CommandLineInterface

    attr_reader :prompt
    attr_accessor :user, :post
    
    def initialize()
        @prompt = TTY::Prompt.new
    end

    # Will ask user if they are a new or returning user and returns the User object
    def greet
        choice = self.prompt.select("Welcome to Student Exchange, the best book exchanging application on campuses throughout USA!\nAre you a new user or returning user?") do |menu|
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

    # Helper method to generate a select menu for user to make a choice
    def select_menu(question, choices)
        self.prompt.select(question, choices)
    end

    # Will return a new post instance 
    def new_post
        puts "Let's create a new post! Please provide me with the following information: "
        name = self.prompt.ask("What is the name of your book: ")
        author = self.prompt.ask("What is the author of your book: ")
        isbn = self.prompt.ask("What is the ISBN of your book: ")
        # Find book in Books db table
        book = Book.find_by(isbn: isbn)
        # Find book does not exist in db table, then lets add this book
        if book == nil
            book = Book.create(name: name, author: author, isbn: isbn)
        end
        # Will find the location from the building name that user selects
        building = self.prompt.select("Choose a location where to meet up: ") do |menu|
            menu.choice "Powdermaker Hall"
            menu.choice "I Building"
            menu.choice "Kiely Hall"
            menu.choice "Science Building"
        end
        location = Location.find_by(building: building)
        content = self.prompt.ask("Provide your potential buyers with a small description (signs of wear, price, special instructions, etc): ")
        # Creates a new post with information provided by user
        new_post = Post.create(user_id: self.user.id, book_id: book.id, content: content, date: "#{Time.now.year}-#{Time.now.month}-#{Time.now.day}", status: 0, location_id: location.id)
    end

    def view_edit_posts
        puts "Here are all your posts: "
        self.view_posts
        choice = self.prompt.select("What would you like to do: ") do |menu|
            menu.choice "Edit a post"
            menu.choice "Delete a post"
            menu.choice "Return to main menu"
        end

        case choice
        when "Edit a post"
            self.edit_post
        when "Delete a post"
            self.delete_post
        when "Return to main menu"
            # method to return to main menu
        end
    end

    def view_posts
        self.user.posts.map do |post|
            post.content
        end
    end
    
    def edit_post
        choice = self.select_menu("Please choose which post to edit: ", self.view_posts)
        # field = self.prompt.multi_select("Which field(s): ", ["Content", "Status", "Location", "Main Menu"])
        field = self.select_menu("Which field would you like to update: ", ["Content", "Status", "Location"])
        post = Post.find_by(content: choice)

        case field
        when "Content"
            new_content = self.prompt.ask("Please provide a new content: ")
            post.update(content: new_content)
            puts "Here is the new post: "
            puts post.content
        when "Status"
            status_changed = self.prompt.select("Has your book been sold? ", {Yes: 0, No: 1})
            if status_changed == 0 # false, meaning post is not active anymore
                post.update(status: 0)
                puts "Your post status has changed to #{post.status}! Congrats on the sale!"
            else
                post.update(status: 1)
                puts "Your post status has changed to #{post.status}! It is visible to potential buyers."
            end
        end
    end

    def delete_post
        choice = self.select_menu("Please choose which post to delete: ", self.view_posts)
        confirm = self.prompt.select("Are you sure you wish to delete this post? ", ["Yes", "No"])
        if confirm == "Yes"
            post = Post.find_by(content: choice)
            post.destroy
            puts "Your post has been deleted!"
        end
        # return to main menu
    end

    # Will allow user to create a new post, find a book post(s), view/edit their posts, or exit to main menu
    def posts
        choice = self.select_menu("Hi there, #{self.user.name}! What would you like to do today?", ["Create a new post", "Find a book", "View or edit my posts", "Exit"])

        case choice
        when "Create a new post"
            self.new_post
            puts "Success! Your post has been uploaded and can be viewed by potential buyers!"
            choice = self.select_menu("What would you like to do now, #{self.user.name}? ", ["Edit this post", "Delete this post", "View all my posts", "Logout"])

            # Choices after user has uploaded a new post
            case choice
            when "Edit this post"
                option = self.prompt.select("Please choose which field to edit: ") do |menu|
                    menu.choice ""
                end
            when "Delete this post"

            when "View all my posts"

            when "Logout"

            end

        when "Find a book"
            Book.find_book
        when "View or edit my posts"
            self.view_edit_posts
        when "Exit"
            # add what will happen
        end
    end

end