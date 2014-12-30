class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications, id: :uuid do |t|
      t.string :subject
      t.text :body
      t.string :sender_type
      t.uuid :sender_id
      t.uuid :user_id
      t.hstore :additional_info
      t.boolean :read, default: true
      t.string :state
      t.boolean :global, default: false
      t.string :type

      t.timestamps
    end

    add_index :notifications, :sender_type
    add_index :notifications, :sender_id
    add_index :notifications, :type
    add_index :notifications, :user_id
  end
end
