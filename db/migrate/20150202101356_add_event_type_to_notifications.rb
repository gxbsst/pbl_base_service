class AddEventTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :event_type, :string

    add_index :notifications, :event_type
  end
end
