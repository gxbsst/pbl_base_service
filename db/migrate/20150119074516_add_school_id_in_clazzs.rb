class AddSchoolIdInClazzs < ActiveRecord::Migration
  def change
    add_column :clazzs, :school_id, :uuid
  end
end
