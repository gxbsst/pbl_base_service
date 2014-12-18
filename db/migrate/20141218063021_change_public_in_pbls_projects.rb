class ChangePublicInPblsProjects < ActiveRecord::Migration
  def change
    change_column_default(:pbls_projects, :public, false)
    remove_column :pbls_products, :form
  end
end
