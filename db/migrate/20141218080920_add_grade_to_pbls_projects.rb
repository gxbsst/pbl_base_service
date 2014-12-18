class AddGradeToPblsProjects < ActiveRecord::Migration
  def change
    add_column :pbls_projects, :grade, :string
    remove_column :pbls_projects, :grade_id
  end
end
