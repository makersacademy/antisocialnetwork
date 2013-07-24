class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :uid
      t.string :activity_id
      t.string :activity_description
      t.datetime :activity_updated_time

      t.timestamps
    end
  end
end
