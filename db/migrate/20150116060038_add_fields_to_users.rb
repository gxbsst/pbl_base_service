class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :realname, :string
    add_column :users, :nickname, :string
    add_column :users, :interests, :text, array: true, default: []
    add_column :users, :disciplines, :text, array: true, default: []

    add_index :users, :realname
    add_index :users, :nickname
  end
end
