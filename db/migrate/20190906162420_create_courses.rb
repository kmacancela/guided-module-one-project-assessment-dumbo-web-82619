class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |course|
      course.string :name
      course.integer :book_id
    end
  end
end
