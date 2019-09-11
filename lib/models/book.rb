class Book < ActiveRecord::Base
    has_many :posts
    has_many :users, through: :posts
    has_many :courses
    has_many :book_topics
    has_many :topics, through: :book_topics

    attr_accessor :user

    def self.prompt
        TTY::Prompt.new
    end
    
end