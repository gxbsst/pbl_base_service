class ChangeGradeInPblsProjects < ActiveRecord::Migration
  def change
    change_column :pbls_projects, :grade, 'integer USING CAST("grade" AS integer)'
  end
end
