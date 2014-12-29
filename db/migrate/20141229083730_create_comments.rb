class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments, id: :uuid do |t|
      t.string :title, :limit => 50, :default => ""
      t.text :comment
      t.string :commentable_type
      t.uuid :commentable_id
      t.uuid :user_id
      t.string :role, :default => "comments"
      t.timestamps
    end

    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
    add_index :comments, :user_id
  end
end
