class DropTableGrades < ActiveRecord::Migration
  def change
    drop_table :grades
  end
end
