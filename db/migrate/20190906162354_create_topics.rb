class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |topic|
      topic.string :name
    end
  end
end
