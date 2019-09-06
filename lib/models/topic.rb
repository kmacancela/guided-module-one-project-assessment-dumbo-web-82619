class Topic < ActiveRecord::Base
    has_many :booktopics
    has_many :books, through: :booktopics
end