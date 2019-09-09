class Book < ActiveRecord::Base
    has_many :posts
    has_many :users, through: :posts
    has_many :courses
    has_many :book_topics
    has_many :topics, through: :book_topics

    def self.tty_prompt
        TTY::Prompt.new
    end

    # Will allow a potential buyer to search for the book they are looking for
    def self.find_book

    end
    
end