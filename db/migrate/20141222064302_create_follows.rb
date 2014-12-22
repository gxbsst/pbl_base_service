class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :follower_id

      t.timestamps
    end
    add_index :follows, [:user_id, :follower_id]
  end
end
