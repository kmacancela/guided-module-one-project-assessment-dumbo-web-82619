class CreateBooktopics < ActiveRecord::Migration[5.2]
  def change
    create_table :booktopics do |booktopic|
      booktopic.integer :book_id
      booktopic.integer :topic_id
    end
  end
end
