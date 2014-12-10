class CreatePblsProjectTechniques < ActiveRecord::Migration
  def change
    create_table :pbls_project_techniques do |t|
      t.uuid :project_id
      t.uuid :technique_id
      t.timestamps
    end
  end
end
