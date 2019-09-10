class Book < ActiveRecord::Base
    has_many :posts
    has_many :users, through: :posts
    has_many :courses
    has_many :book_topics
    has_many :topics, through: :book_topics

    def self.prompt
        TTY::Prompt.new
    end

    # Will allow a potential buyer to search for the book they are looking for
    def self.find_book
        choice = self.prompt.select("Please provide me with the title, author, or ISBN of the book you are searching for: ") do |menu|
            menu.choice "Title"
            menu.choice "Author"
            menu.choice "ISBN"
        end

        case choice
        when "Title"
            title = self.prompt.ask("Please enter the title: ")
            book = Book.where('name LIKE ?', "%#{title}%")
            if book[0] == nil || book[0].posts == nil
                puts "Sorry, there are no posts for \"#{title}\" at the moment. Check back soon!"
                # Add main menu method here
            else
                puts "Here are the open posts for \"#{title}\": "
                book[0].posts.map do |post|
                    puts post.content
                end
                # Another menu here
            end
        end
    end
    
end