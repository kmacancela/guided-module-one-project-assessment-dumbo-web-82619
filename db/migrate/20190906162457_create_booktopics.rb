class CreateBooktopics < ActiveRecord::Migration[6.0]
  def change
    create_table :booktopics do |booktopic|
      booktopic.integer :book_id
      booktopic.integer :topic_id
    end
  end
end
