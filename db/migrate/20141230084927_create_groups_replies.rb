class CreateGroupsReplies < ActiveRecord::Migration
  def change
    create_table :groups_replies, id: :uuid do |t|
      t.uuid :post_id
      t.uuid :user_id
      t.text :body
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :groups_replies, :user_id
    add_index :groups_replies, :post_id
  end
end
