class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |book|
      book.string :name 
      book.string :author
      book.string :isbn
    end
  end
end
