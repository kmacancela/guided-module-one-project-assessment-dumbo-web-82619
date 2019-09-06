class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |location|
      location.string :building
    end
  end
end
