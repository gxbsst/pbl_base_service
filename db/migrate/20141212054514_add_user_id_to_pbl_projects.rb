class AddUserIdToPblProjects < ActiveRecord::Migration
  def change
    add_column :pbls_projects, :user_id, :uuid, index: true
  end
end
