class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |course|
      course.string :name
    end
  end
end
