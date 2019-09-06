class CreateBookTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :book_topics do |book_topic|
      book_topic.integer :book_id
      book_topic.integer :topic_id
    end
  end
end
