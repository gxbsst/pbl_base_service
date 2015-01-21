class AddRelationToFriendShips < ActiveRecord::Migration
  def change
    add_column :friend_ships, :relation, :string
  end
end
