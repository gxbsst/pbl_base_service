class AddRecommendAndPositionToPblsProjects < ActiveRecord::Migration
  def change
    add_column :pbls_projects, :recommend, :boolean, default: false
    add_column :pbls_projects, :position, :integer, default: 0

    add_index :pbls_projects, :recommend
  end
end
