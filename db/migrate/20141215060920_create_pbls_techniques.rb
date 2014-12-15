class CreatePblsTechniques < ActiveRecord::Migration
  def change
    create_table :pbls_techniques, id: :uuid do |t|
      t.uuid :project_id, index: true
      t.uuid :technique_id, index: true

      t.timestamps
    end
  end
end
