class CreateCharities < ActiveRecord::Migration
  def change
    create_table :charities do |t|
      t.string :name
      t.integer :registered_number
      t.text :activities
      t.string :image
      t.string :url

      t.timestamps
    end
  end
end
