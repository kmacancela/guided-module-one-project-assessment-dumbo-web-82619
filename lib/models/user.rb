class User < ActiveRecord::Base
    has_many :posts
    has_many :books, through: :posts

    def self.prompt
        TTY::Prompt.new
    end

    def self.handle_new_user
        username = self.prompt.ask("Enter a username: ")
        password = self.prompt.mask("Enter a password: ")
        name = self.prompt.ask("Enter your name: ")
        User.create(username: username , password: password, name: name)
    end

    def self.handle_returning_user
        username = self.prompt.ask("Welcome back! Enter your username: ")
        password = self.prompt.mask("Enter your password: ")
        User.find_by(username: username, password: password)
    end
    
end