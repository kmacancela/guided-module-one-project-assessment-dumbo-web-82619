class CommandLineInterface

    attr_reader :prompt
    attr_accessor :user, :post
    
    def initialize()
        @prompt = TTY::Prompt.new
    end

    # Will ask user if they are a new or returning user and returns the User object
    def greet
        choice = self.prompt.select("Welcome to Student Exchange, the best book exchanging application on campuses throughout USA!\nAre you a new user or returning user?", ["New User", "Returning User", "Exit"])

        # Based on the user's choice, will redirect them to the appropriate User method
        # We set the user instance object to the user object we created (new user) or retrieved (returning user)
        case choice
        when "New User"
            user = User.handle_new_user
            self.user = user
            self.main_menu
        when "Returning User"
            user = User.handle_returning_user
            self.user = user
            self.main_menu
        when "Exit"
            exit
        end 
    end

    def spinner(content)
        lines = [" | ", " / ", " - ", " \ ", " | "]
        colors = []
        5.times do
            lines.length.times do |line|
                system "clear"
                puts lines[line] + content + lines[line]
                sleep(0.1)
            end
        end
        system "clear"
        return " "
    end

    def new_post_create(book, title = nil, author = nil, isbn= nil)
        if book == nil
            book = Book.create(title: title, author: author, isbn: isbn)
        end
        # end
        # Will find the location from the building name that user selects
        building = self.prompt.select("Choose a location where to meet up: ", ["Powdermaker Hall", "I Building", "Kiely Hall", "Science Building"])
        location = Location.find_by(building: building)
        content = self.prompt.ask("Provide your potential buyers with a small description (signs of wear, price, special instructions, etc): ")
        # Creates a new post with information provided by user
        new_post = Post.create(user_id: self.user.id, book_id: book.id, content: content, date: "#{Time.now.year}-#{Time.now.month}-#{Time.now.day}", status: 1, location_id: location.id)
        self.spinner("Uploading")
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

    # Will return a new post instance 
    def new_post
        puts "Let's create a new post! Please provide me with the following information: "
        

        isbn = self.prompt.ask("What is the ISBN of your book: ")
        book = Book.find_by(isbn: isbn)
        if book != nil
            confirm = self.prompt.select("Are you looking for #{book.title} by #{book.author}? ", ["Yes", "No"])
            if confirm == "No"
                self.main_menu
            else
                self.new_post_create(book)
            end
        else # if book is nil
            title = self.prompt.ask("What is the title of your book: ")
            author = self.prompt.ask("What is the author of your book: ")
            self.new_post_create(book, title, author, isbn)
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

    # Will show all users all their posts and reloads from db each time
    def view_posts
        self.user.posts.map do |post|
            post.reload.content
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
            choice = self.prompt.select("Please choose which post to delete: ", [self.view_posts, "Back to main menu"])
            if choice == "Back to main menu"
                abort
            else
                post = Post.find_by(content: choice)
            end
        else
            confirm = self.prompt.select("Are you sure you wish to delete this post? ", ["Yes", "No"])
            if confirm == "Yes"
                post.destroy
                puts "Your post has been deleted!"
            end
        end
        self.main_menu
    end

    # Helper method for find_book method
    def find_book_open_posts(choice)
        input = self.prompt.ask("Please enter the #{choice}: ")
        book = Book.where("#{choice.downcase} LIKE ?", "%#{input}%")
        if book[0] == nil
            open_posts = nil
            puts "Sorry, no such book :("
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
            format = open_posts.map do |post|
                "#{User.find_by(id: post.user_id).name} says #{post.content} about #{Book.find_by(id: post.book_id).title} by #{Book.find_by(id: post.book_id).author} - They will be located in #{Location.find_by(id: post.location_id).building}"
            end
            puts format

            # post_info = open_posts.map do |post|
            #     # {post => post.content}
            #     [post.content, post.user.name, post.location.building]
            # end

            # # index = 0
            # contents = []
            # users = []
            # locations = []
            # index = 0
            # post_info.each do |element|
            #     # puts index
            #     if index % 3 == 0
            #         contents << element
            #     elsif index % 3 == 1
            #         users << element
            #     else
            #         locations << element
            #     end
            #     index += 1
            # end

            # puts "Contents: "
            # puts contents





            # puts "Here are the available posts with this #{choice.downcase}: "
            # puts post_info.flatten[0] # CHANGE THIS
            # puts post_info.flatten[1]
            # puts post_info.flatten[2]
            # puts post_info.flatten[3]
            # # Make this into a TTY table
        end
    end

    # Will allow a potential buyer to search for the book they are looking for
    def find_book
        choice = self.prompt.select("Please provide me with the title, author, or ISBN of the book you are searching for: ", ["Title", "Author", "ISBN"])
        find_book_open_posts(choice)
        self.main_menu
    end

    def delete_account
        confirm = self.prompt.select("Are you sure you wish to delete your account? (We'll miss you!)", {Yes: 0, No: 1})
        if confirm == 1
            puts "Glad you decided to stay!"
            self.main_menu
        else 
            self.user.destroy
            puts ">:D Your account has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:DYour account has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|our account has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dour account has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|ur account has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dur account has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|r account has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dr account has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:| account has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:D account has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|account has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Daccount has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|ccount has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dccount has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|count has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dcount has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|ount has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dount has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|unt has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dunt has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|nt has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dnt has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|t has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dt has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:| has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:D has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|has been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dhas been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|as been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Das been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|s been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Ds been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:| been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:D been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|been destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dbeen destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|een destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Deen destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|en destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Den destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|n destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dn destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:| destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:D destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Ddestroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|estroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Destroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|stroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dstroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|troyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dtroyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|royed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Droyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|oyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Doyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|yed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dyed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|ed! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Ded! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|d! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:Dd! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:|! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:D! Muhaha!"
            sleep(0.1)
            system "clear"
            puts ">:| Muhaha!"
            sleep(0.1)
            system "clear"
            self.greet
        end
    end

    # Will allow user to create a new post, find a book post(s), view/edit their posts, or exit to main menu
    def main_menu
        choice = self.prompt.select("Hi there, #{self.user.name}! What would you like to do today?", ["Create a new post", "Find a book", "View or edit my posts", "Delete my account", "Logout"])

        case choice
        when "Create a new post"
            self.new_post
        when "Find a book"
            self.find_book
        when "View or edit my posts"
            self.view_edit_posts
        when "Delete my account"
            self.delete_account
        when "Logout"
            puts "Goodbye!"
            self.greet
        end
    end

end