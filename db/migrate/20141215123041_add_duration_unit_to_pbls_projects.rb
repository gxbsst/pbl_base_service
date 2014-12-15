class AddDurationUnitToPblsProjects < ActiveRecord::Migration
  def change
    add_column :pbls_projects, :duration_unit, :string
  end
end
