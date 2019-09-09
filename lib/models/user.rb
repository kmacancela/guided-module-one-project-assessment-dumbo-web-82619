class User < ActiveRecord::Base
    has_many :posts
    has_many :books, through: :posts

    def user_posts
        self.posts.select do |post|
            post.user_id == self.id
        end
    end

    def self.prompt
        prompt = TTY::Prompt.new
    end

    def self.new_user
        name = self.prompt.ask("Enter your name: ")
        User.new(name: name)
    end

    def self.existing_user
        self.destroy_all
        name = self.prompt.ask("Enter your name: ")
        if User.find_by(name: name)
            User.find_by(name: name).name
        else
            "ERROR: User Not Found"
        end
    end

    

end