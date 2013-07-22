class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :create
      t.string :show
      t.string :index

      t.timestamps
    end
  end
end
