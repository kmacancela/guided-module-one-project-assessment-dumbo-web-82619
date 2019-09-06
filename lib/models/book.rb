class Book < ActiveRecord::Base
    has_many :posts
    has_many :users, through: :posts
    has_many :courses
    has_many :booktopics
    has_many :topics, through :booktopics
end