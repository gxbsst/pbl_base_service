class CreateFeedsMessages < ActiveRecord::Migration
  def change
    create_table :feeds_messages, id: :uuid do |t|
      t.uuid :post_id
      t.uuid :sender_id
      t.uuid :user_id
      t.integer :post_no
      t.integer :hotness

      t.timestamps
    end

    add_index :feeds_messages, :post_id
    add_index :feeds_messages, :user_id
    add_index :feeds_messages, :sender_id
  end
end
