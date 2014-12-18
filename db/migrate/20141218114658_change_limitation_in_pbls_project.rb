class ChangeLimitationInPblsProject < ActiveRecord::Migration
  def change
    change_column :pbls_projects, :limitation, 'integer USING CAST("limitation" AS integer)'
  end
end
