class BookTopic < ActiveRecord::Base
    belongs_to :book
    belongs_to :topic

    def self.tty_prompt
        TTY::Prompt.new
    end
    
end