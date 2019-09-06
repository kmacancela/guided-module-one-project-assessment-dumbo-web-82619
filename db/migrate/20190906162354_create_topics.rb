class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |topic|
      topic.string :name
    end
  end
end
