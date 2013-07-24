class AddFbAccessExpiresAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :fb_access_expires_at, :string
  end
end
