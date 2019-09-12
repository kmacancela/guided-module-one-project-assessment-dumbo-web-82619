class User < ActiveRecord::Base
    has_many :posts
    has_many :books, through: :posts

    def self.prompt
        TTY::Prompt.new
    end

    def self.handle_new_user
        taken = true
        while taken do

            puts " "
            username_prompt = "Enter a " + "username: ".colorize(:light_blue)
            username = self.prompt.ask(username_prompt)
            puts "-" * "Enter a username: ".length
            puts String.modes

            if User.find_by(username: username)
                puts " "
                puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".yellow.on_light_red.blink
                statement = "Username is " + "taken".upcase.colorize(:red) + ", please enter another."
                puts statement
                puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".yellow.on_light_red.blink
                puts " "
            else
                taken = false
            end

        end
        password = self.prompt.mask("Enter a password: ")
        puts "-" * "Enter a password: ".length
        name = self.prompt.ask("Enter your name: ")
        puts "-" * "Enter your name: ".length
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
            end
        end
        login
    end
    
end