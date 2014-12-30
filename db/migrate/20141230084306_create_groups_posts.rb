class CreateGroupsPosts < ActiveRecord::Migration
  def change
    create_table :groups_posts, id: :uuid do |t|
      t.uuid :group_id
      t.uuid :user_id
      t.string :subject
      t.text :body
      t.integer :likes_count, default: 0
      t.integer :forwardeds_count, default: 0
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :groups_posts, :user_id
    add_index :groups_posts, :group_id
  end
end
