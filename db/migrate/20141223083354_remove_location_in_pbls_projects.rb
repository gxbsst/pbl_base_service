class RemoveLocationInPblsProjects < ActiveRecord::Migration
  def change
    remove_column :pbls_projects, :location_id
  end
end
