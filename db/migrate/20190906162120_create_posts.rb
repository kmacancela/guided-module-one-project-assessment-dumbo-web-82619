class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |post|
      post.integer :user_id 
      post.integer :book_id
      post.string :content
      post.string :date
      post.string :status
      post.integer :location_id
    end
  end
end
