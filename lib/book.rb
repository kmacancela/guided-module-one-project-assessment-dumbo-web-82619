class Book < ActiveRecord::Base
    has_many :posts
    has_many :courses
    has_many :booktopics
end