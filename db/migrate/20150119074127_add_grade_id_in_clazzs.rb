class AddGradeIdInClazzs < ActiveRecord::Migration
  def change
    add_column :clazzs, :grade_id, :integer
  end
end
