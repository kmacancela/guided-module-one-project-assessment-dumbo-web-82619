class User < ActiveRecord::Base
    has_many :posts
    has_many :books, through: :posts

    def self.tty_prompt
        TTY::Prompt.new
    end

    def self.handle_new_user
        username = self.tty_prompt.ask("Enter a username: ")
        password = self.tty_prompt.mask("Enter a password: ")
        name = self.tty_prompt.ask("Enter your name: ")
        User.create(username: username , password: password, name: name)
    end

    def self.handle_returning_user
        username = self.tty_prompt.ask("Welcome back! Enter your username: ")
        password = self.tty_prompt.mask("Enter your password: ")
        User.find_by(username: username, password: password)
    end

end