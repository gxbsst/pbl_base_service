class AddSchoolIdAndGradeIdAndClazzIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :school_id, :uuid
    add_column :users, :grade_id, :integer
    add_column :users, :clazz_id, :uuid
  end
end
