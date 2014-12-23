class RemoveGradeInPblsProjects < ActiveRecord::Migration
  def change
    remove_column :pbls_projects, :grade
    add_column :pbls_projects, :grade, :string
  end
end
