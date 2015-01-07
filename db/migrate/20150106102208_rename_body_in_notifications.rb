class RenameBodyInNotifications < ActiveRecord::Migration
  def change
    rename_column :notifications, :body,  :content
  end
end
