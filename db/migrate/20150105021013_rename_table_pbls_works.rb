class RenameTablePblsWorks < ActiveRecord::Migration
  def change
    rename_table :pbls_works, :assignments_works
  end
end
