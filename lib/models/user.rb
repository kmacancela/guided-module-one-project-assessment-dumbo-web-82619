class User < ActiveRecord::Base
    has_many :posts
    has_many :books, through: :posts

    def user_posts
        self.posts.select do |post|
            post.user_id == self.id
        end
    end
end