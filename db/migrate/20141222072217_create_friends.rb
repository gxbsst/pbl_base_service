class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :friend_id

      t.timestamps
    end
  end
end
