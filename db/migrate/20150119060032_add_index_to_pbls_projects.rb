class AddIndexToPblsProjects < ActiveRecord::Migration
  def change
    add_index :pbls_projects, :name
    add_index :pbls_projects, :user_id
  end
end
