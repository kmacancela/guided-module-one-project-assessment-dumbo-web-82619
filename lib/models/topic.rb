class Topic < ActiveRecord::Base
    has_many :book_topics
    has_many :books, through: :book_topics
end