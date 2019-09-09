class Post < ActiveRecord::Base
    belongs_to :user
    belongs_to :location
    belongs_to :book

    def self.tty_prompt
        TTY::Prompt.new
    end

    def self.new_post
        name = self.tty_prompt.ask("What is the name of your book: ")
        author = self.tty_prompt.ask("What is the author of your book: ")
        isbn = self.tty_prompt.ask("What is the ISBN of your book: ")
        # Find book in Books db table
        book = Book.find_by(isbn: isbn)
        # Find book does not exist in db table, then lets add this book
        if book == nil
            book = Book.create(name: name, author: author, isbn: isbn)
        end
        location = self.tty_prompt.select("Choose a location where to meet up: ") do |menu|
            menu.choice "Powdermaker Hall"
            menu.choice "I Building"
            menu.choice "Kiely Hall"
            menu.choice "Science Building"
        end
        content = self.tty_prompt.ask("Provide your potential buyers with a small description (signs of wear, price, special instructions, etc): ")

        # Create a new post with information provided by user
        # Post.create()

    end

    def self.view_posts
        self.user.posts.map do |post|
            puts post.content
        end
    end

    def self.edit_post

    end

end