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

    # Will return a new post instance 
    def new_post
        puts "Let's create a new post! Please provide me with the following information: "
        title = self.prompt.ask("What is the title of your book: ")
        author = self.prompt.ask("What is the author of your book: ")
        isbn = self.prompt.ask("What is the ISBN of your book: ")
        # Find book in Books db table
        book = Book.find_by(isbn: isbn)
        # Find book does not exist in db table, then lets add this book
        if book == nil
            book = Book.create(title: title, author: author, isbn: isbn)
        end
        # Will find the location from the building name that user selects
        building = self.prompt.select("Choose a location where to meet up: ", ["Powdermaker Hall", "I Building", "Kiely Hall", "Science Building"])
        location = Location.find_by(building: building)
        content = self.prompt.ask("Provide your potential buyers with a small description (signs of wear, price, special instructions, etc): ")
        # Creates a new post with information provided by user
        new_post = Post.create(user_id: self.user.id, book_id: book.id, content: content, date: "#{Time.now.year}-#{Time.now.month}-#{Time.now.day}", status: 1, location_id: location.id)

        puts "Success! Your post has been uploaded and can be viewed by potential buyers!"
        choice = self.prompt.select("What would you like to do now, #{self.user.name}? ", ["Edit this post", "Delete this post", "Return to main menu"])

        # Choices after user has uploaded a new post are to edit the post that was just created, delete it, or return to main menu
        case choice
        when "Edit this post"
            self.edit_post(new_post)
        when "Delete this post"
            self.delete_post(new_post)
        when "Return to main menu"
            self.main_menu
        end
    end

    def view_edit_posts
        puts "Here are all your posts: "
        puts self.view_posts
        choice = self.prompt.select("What would you like to do: ", ["Edit a post", "Delete a post", "Return to main menu"])

        case choice
        when "Edit a post"
            self.edit_post
        when "Delete a post"
            self.delete_post
        when "Return to main menu"
            self.main_menu
        end
    end

    def view_posts
        self.user.posts.map do |post|
            post.content
        end
    end
    
    def edit_post(post = nil)
        if post == nil
            choice = self.prompt.select("Please choose which post to edit: ", [self.view_posts, "Return to main menu"])
            post = Post.find_by(content: choice)
        end
        if choice == "Return to main menu"
            self.main_menu
        else
            # Check how to do multi select for the below so user can edit more than 1 field
            field = self.prompt.select("Which field would you like to update: ", ["Content", "Status", "Location"])

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
            when "Location"
                location_changed = self.prompt.select("Please select a new location: ", ["Powdermaker Hall", "I Building", "Kiely Hall", "Science Building"])
                building = Location.find_by(building: location_changed)
                post.update(location_id: building.id)
                puts "Your post location has changed to #{building.building}!"
            end
            self.main_menu
        end
    end

    def delete_post(post = nil)
        if post == nil
            choice = self.prompt.select("Please choose which post to delete: ", self.view_posts)
            post = Post.find_by(content: choice)
        end
        confirm = self.prompt.select("Are you sure you wish to delete this post? ", ["Yes", "No"])
        if confirm == "Yes"
            post.destroy
            puts "Your post has been deleted!"
        end
        self.main_menu
    end

    # Helper method for find_book method
    def find_book_open_posts(choice)
        input = self.prompt.ask("Please enter the #{choice}: ")
        book = Book.where("#{choice.downcase} LIKE ?", "%#{input}%")
        if book[0] == nil
            open_posts = nil
        else
            book_posts = book.map do |book|
                book.posts
            end
            book_posts.flatten!
            open_posts = book_posts.select do |post|
                post.status == true 
            end
        end
        if open_posts == nil
            puts "Sorry, there are no posts for this #{choice.downcase} at the moment. Check back soon!"
        else
            puts "Here are the available posts with this #{choice.downcase}: "
            puts open_posts
            # Make this into a TTY table
        end
    end

    # Will allow a potential buyer to search for the book they are looking for
    def find_book
        choice = self.prompt.select("Please provide me with the title, author, or ISBN of the book you are searching for: ", ["Title", "Author", "ISBN"])
        find_book_open_posts(choice)
        self.main_menu
    end

    # Will allow user to create a new post, find a book post(s), view/edit their posts, or exit to main menu
    def main_menu
        choice = self.prompt.select("Hi there, #{self.user.name}! What would you like to do today?", ["Create a new post", "Find a book", "View or edit my posts", "Exit"])

        case choice
        when "Create a new post"
            self.new_post
        when "Find a book"
            self.find_book
        when "View or edit my posts"
            self.view_edit_posts
        when "Exit"
            puts "Goodbye!"
            exit
        end
    end

end