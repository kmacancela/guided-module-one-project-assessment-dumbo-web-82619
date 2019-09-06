class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |user|
      user.string :name
    end
  end
end
