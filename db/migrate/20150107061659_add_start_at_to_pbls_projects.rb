class AddStartAtToPblsProjects < ActiveRecord::Migration
  def change
    add_column :pbls_projects, :start_at, :datetime
  end
end
