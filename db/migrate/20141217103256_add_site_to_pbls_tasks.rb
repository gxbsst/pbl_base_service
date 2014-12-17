class AddSiteToPblsTasks < ActiveRecord::Migration
  def change
    add_column :pbls_tasks, :site, :string
  end
end
