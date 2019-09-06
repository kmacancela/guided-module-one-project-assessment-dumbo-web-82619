class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |book|
      book.string :name 
      book.string :author
      book.integer :isbn
    end
  end
end
