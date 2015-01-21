class RemoveClazzIdInUsers < ActiveRecord::Migration
  def change
    remove_column :users, :grade_id
    remove_column :users, :clazz_id
  end
end
