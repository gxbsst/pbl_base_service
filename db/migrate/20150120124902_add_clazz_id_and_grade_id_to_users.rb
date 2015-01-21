class AddClazzIdAndGradeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :grade_id, :text, array: true, default: []
    add_column :users, :clazz_id, :text, array: true, default: []
  end
end
