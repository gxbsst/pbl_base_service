class AddRegionIdToPblsProjects < ActiveRecord::Migration
  def change
    add_column :pbls_projects, :region_id, :uuid
  end
end
