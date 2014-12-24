class RenameFriendToFriendShip < ActiveRecord::Migration
  def change
    rename_table :friends, :friend_ships
  end
end
