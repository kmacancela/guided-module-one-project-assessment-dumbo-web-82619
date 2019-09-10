class Post < ActiveRecord::Base
    belongs_to :user
    belongs_to :location
    belongs_to :book

    def self.prompt
        TTY::Prompt.new
    end

    def edit_post

    end

end