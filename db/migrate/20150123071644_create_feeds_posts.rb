class CreateFeedsPosts < ActiveRecord::Migration
  def up
    create_table :feeds_posts, id: :uuid do |t|
      t.string :title
      t.text :content
      t.integer :no
      t.integer :like_count, default: 0
      t.boolean :blocked, default: false
      t.string :owner_type
      t.uuid :owner_id
      t.uuid :user_id
      t.uuid :sender_id
      t.uuid :resource_id
      t.integer :hotness, default: 0


      t.timestamps
    end

    execute <<-SQL
      CREATE SEQUENCE feeds_post_no_seq
       INCREMENT 1
       MINVALUE 1
       MAXVALUE 9223372036854775807
       START 1
       CACHE 1;
    SQL


    add_index :feeds_posts, [:owner_id, :owner_type]
    add_index :feeds_posts, [:user_id]
    add_index :feeds_posts, [:sender_id]
    add_index :feeds_posts, [:content]
    add_index :feeds_posts, [:title]
  end

  def down
    execute <<-SQL
      DROP SEQUENCE feeds_post_no_seq
    SQL

    remove_index :feeds_posts, [:owner_id, :owner_type]
    remove_index :feeds_posts, [:user_id]
    remove_index :feeds_posts, [:sender_id]
    remove_index :feeds_posts, [:content]
    remove_index :feeds_posts, [:title]

    drop_table :feeds_posts
  end
end
