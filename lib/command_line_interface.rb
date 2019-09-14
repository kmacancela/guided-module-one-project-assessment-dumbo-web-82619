class CommandLineInterface

    attr_reader :prompt
    attr_accessor :user, :post
    
    def initialize()
        @prompt = TTY::Prompt.new
    end

    # Will ask user if they are a new or returning user and returns the User object
    def greet
        system "clear"
        self.spinner("Loading App")
        self.spinner("🔺  Enumerati-ing  🔺 ")
        welcome = "Welcome".colorize(:light_green)
        se = "Student Exchange".colorize(:light_magenta)
        puts "_".colorize(:light_green) * "Welcome to Student Exchange, the best book exchanging application on campuses throughout USA!".length
        choice = self.prompt.select("Welcome to ".colorize(:light_green) + "Student Exchange".colorize(:color => :light_magenta, :mode => :bold) + ", the best book exchanging application on campuses throughout USA!\n".colorize(:light_green) + "Are you a new user or returning user?".colorize(:color => :light_green).underline, ["New User", "Returning User", "Exit"])
        puts " "
        # Based on the user's choice, will redirect them to the appropriate User method
        # We set the user instance object to the user object we created (new user) or retrieved (returning user)
        case choice
        when "New User"
            user = User.handle_new_user
            self.spinner("Creating Account")
            self.user = user
            self.main_menu
        when "Returning User"
            user = User.handle_returning_user
            self.spinner("Restoring Session")
            self.user = user
            self.main_menu
        when "Exit"
            puts "Smell ya later! 🦄"
            exit
        end 
    end

    def spinner(content)
        lines = [" |  ".colorize(:color => :light_red), " /  ".colorize(:color => :light_blue), " -  ".colorize(:color => :light_cyan), " \\  ".colorize(:color => :light_yellow)]
        reverse = [" |  ".colorize(:color => :light_red), " \\  ".colorize(:color => :light_blue), " -  ".colorize(:color => :light_cyan), " /  ".colorize(:color => :light_yellow)]
        5.times do
            lines.length.times do |line|
                system "clear"
                puts "#{lines[line]} #{content} #{reverse[line]}"
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
        isbn = self.prompt.ask("Let's create a new post! Please provide me with the ISBN of your book: ")
        book = Book.find_by(isbn: isbn)
        while book != nil
            confirm = "No"
            while confirm == "No" && book != nil
                confirm = self.prompt.select("Book found! Are you looking to add a new post for \"#{book.title}\" by #{book.author}?", ["Yes", "No", "Back to main menu"])
                if confirm == "Yes"
                    self.new_post_create(book)
                elsif confirm == "No"
                    isbn = self.prompt.ask("Please provide me with the ISBN of your book again: ")
                    book = Book.find_by(isbn: isbn)
                else
                    self.main_menu
                end
            end
        end
        if book == nil
            title = self.prompt.ask("What is the title of your book: ")
            author = self.prompt.ask("What is the author of your book: ")
            self.new_post_create(book, title, author, isbn)
        end
    end

    def view_edit_posts
        posts = self.view_posts
        if posts == []
            puts "Sorry, no posts to show..."
            self.main_menu
        else
            puts "Here are all your posts: "
            i = 5
            self.view_posts.each do |post|
                puts ">".colorize(String.colors[i]) * post.length
                puts post
                puts "<".colorize(String.colors[i]) * post.length
                i += 2
            end
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
        if choice != "Return to main menu"
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
            user.reload.posts
        end
        self.main_menu
    end

    # Deletes a post from db Post table. If post is passed as argument, will delete that Post instance. If not passed, user will choose which Post instance first. Will take them back to main menu after post has been deleted.
    def delete_post(post = nil)
        if post == nil
            choice = self.prompt.select("Please choose which post to delete: ", [self.view_posts, "Back to main menu"])
            if choice != "Back to main menu"
                post = Post.find_by(content: choice)
                post.destroy
                puts "Your post has been deleted!"
                user.reload.posts
            end
        # we now have a post object
        # choice is nil only if post was passed as an argument
        else 
            confirm = self.prompt.select("Are you sure you wish to delete this post? ", ["Yes", "No"])
            if confirm == "Yes"
                post.destroy
                puts self.spinner("ANNIHILATING")
                puts "Your post has been deleted!"
            end
        end
        # always back to main menu
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

            i = 5
            format.each do |post|
                puts ">".colorize(String.colors[i]) * post.length
                puts post
                puts "<".colorize(String.colors[i]) * post.length
                i += 2
            end
        end
    end

    # Will allow a potential buyer to search for the book they are looking for
    def find_book
        choice = self.prompt.select("Please provide me with the title, author, or ISBN of the book you are searching for: ", ["Title", "Author", "ISBN", "Back to main menu"])
        if choice != "Back to main menu"
            find_book_open_posts(choice)
        end
        self.main_menu
    end

    def delete_account
        confirm = self.prompt.select("Are you sure you wish to delete your account? (We'll miss you!)", {Yes: 0, No: 1})
        if confirm == 1
            puts "Glad you decided to stay! 🤪\n\n"
            self.main_menu
        else 
            self.spinner("Forever goodbye-ing 😢")
            self.user.destroy
            self.user.posts.each do |post|
                post.destroy
            end
            open_mouth = '>:D'.colorize(:light_blue)
            closed_mouth = '>:|'.colorize(:light_red)
            puts "#{open_mouth} Your account has been destroyed! Muhaha!"
            sleep(1)
            system "clear"
            puts " #{open_mouth}Your account has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "  #{closed_mouth}our account has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "  #{open_mouth}our account has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "   #{closed_mouth}ur account has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "   #{open_mouth}ur account has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "    #{closed_mouth}r account has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "    #{open_mouth}r account has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "     #{closed_mouth} account has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "     #{open_mouth} account has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "      #{closed_mouth}account has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "      #{open_mouth}account has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "       #{closed_mouth}ccount has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "       #{open_mouth}ccount has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "        #{closed_mouth}count has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "        #{open_mouth}count has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "         #{closed_mouth}ount has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "         #{open_mouth}ount has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "          #{closed_mouth}unt has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "          #{open_mouth}unt has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "           #{closed_mouth}nt has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "           #{open_mouth}nt has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "            #{closed_mouth}t has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "            #{open_mouth}t has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "             #{closed_mouth} has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "             #{open_mouth} has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "              #{closed_mouth}has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "              #{open_mouth}has been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "               #{closed_mouth}as been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "               #{open_mouth}as been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                #{closed_mouth}s been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                #{open_mouth}s been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                 #{closed_mouth} been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                 #{open_mouth} been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                  #{closed_mouth}been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                  #{open_mouth}been destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                   #{closed_mouth}een destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                   #{open_mouth}een destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                    #{closed_mouth}en destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                    #{open_mouth}en destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                     #{closed_mouth}n destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                     #{open_mouth}n destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                      #{closed_mouth} destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                      #{open_mouth} destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                       #{closed_mouth}destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                       #{open_mouth}destroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                        #{closed_mouth}estroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                        #{open_mouth}estroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                         #{closed_mouth}stroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                         #{open_mouth}stroyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                          #{closed_mouth}troyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                          #{open_mouth}troyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                           #{closed_mouth}royed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                           #{open_mouth}royed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                            #{closed_mouth}oyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                            #{open_mouth}oyed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                             #{closed_mouth}yed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                             #{open_mouth}yed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                              #{closed_mouth}ed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                              #{open_mouth}ed! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                               #{closed_mouth}d! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                               #{open_mouth}d! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                                #{closed_mouth}! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                                #{open_mouth}! Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                                 #{closed_mouth} Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                                 #{open_mouth} Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                                  #{closed_mouth}Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                                  #{open_mouth}Muhaha!"
            sleep(0.075)
            system "clear"
            puts "                                   #{closed_mouth}uhaha!"
            sleep(0.075)
            system "clear"
            puts "                                   #{open_mouth}uhaha!"
            sleep(0.075)
            system "clear"
            puts "                                    #{closed_mouth}haha!"
            sleep(0.075)
            system "clear"
            puts "                                    #{open_mouth}haha!"
            sleep(0.075)
            system "clear"
            puts "                                     #{closed_mouth}aha!"
            sleep(0.075)
            system "clear"
            puts "                                     #{open_mouth}aha!"
            sleep(0.075)
            system "clear"
            puts "                                      #{closed_mouth}ha!"
            sleep(0.075)
            system "clear"
            puts "                                      #{open_mouth}ha!"
            sleep(0.075)
            system "clear"
            puts "                                       #{closed_mouth}a!"
            sleep(0.075)
            system "clear"
            puts "                                       #{open_mouth}a!"
            sleep(0.075)
            system "clear"
            puts "                                        #{closed_mouth}!"
            sleep(0.075)
            system "clear"
            puts "                                        #{open_mouth}!"
            sleep(0.075)
            system "clear"
            puts "                                         #{closed_mouth}"
            sleep(0.15)
            system "clear"
            puts "!                                        #{closed_mouth}"
            sleep(0.15)
            system "clear"
            puts "m!                                       #{closed_mouth}"
            sleep(0.15)
            system "clear"
            puts "um!                                      #{closed_mouth}"
            sleep(0.15)
            system "clear"
            puts "Yum!                                     #{closed_mouth}"
            sleep(1)
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
            self.spinner("  ✌️✌️✌️  ")
            self.greet
        end
    end

end