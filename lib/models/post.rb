class Post < ActiveRecord::Base
    belongs_to :user
    belongs_to :location
    belongs_to :book

    def self.tty_prompt
        TTY::Prompt.new
    end

    def self.new_posts
        # self.prompt.
    end

end