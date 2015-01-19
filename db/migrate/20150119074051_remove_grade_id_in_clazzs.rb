class RemoveGradeIdInClazzs < ActiveRecord::Migration
  def change
    remove_column :clazzs, :grade_id
  end
end
