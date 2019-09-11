class User < ActiveRecord::Base
    has_many :posts
    has_many :books, through: :posts

    def self.prompt
        TTY::Prompt.new
    end

    def self.handle_new_user
        taken = true
        while taken do

            username = self.prompt.ask("Enter a username: ")

            if User.find_by(username: username)
                puts "Username is taken, please enter another."
            else
                taken = false
            end

        end
        password = self.prompt.mask("Enter a password: ")
        name = self.prompt.ask("Enter your name: ")
        User.create(username: username, password: password, name: name)
    end

    def self.handle_returning_user
        i = 0
        username = self.prompt.ask("Welcome back! Enter your username: ")
        login = User.find_by(username: username)
        until login do 
            puts "Username not found, please enter valid username"
            username = self.prompt.ask("Enter your username: ")
            login = User.find_by(username: username)
        end
        password = self.prompt.mask("Enter your password: ")
        while login.password != password do
            if login.password != password
                puts "Wrong password, try again"
                i += 1
                password = self.prompt.mask("Enter the right password this time: ")
            end
            if i > 3 && password != login.password
                time = i * 5
                mins = 0 
                seconds = 0
                while time != 0 do
                    system "clear"
                    mins = time / 60
                    seconds = time - (mins * 60)
                    second_s = "s"
                    min_s = "s"
                    if seconds == 1
                        second_s = ""
                    end
                    if mins == 1
                        min_s = ""
                    end
                    message = "You are locked out for the next #{mins} minute#{min_s} and #{seconds} second#{second_s}"
                    puts message
                    time -= 1
                    sleep(1)
                end
                # sleep(i * 36)
            end
        end
        login
    end
    
end