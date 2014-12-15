class CreatePblsKnowledges < ActiveRecord::Migration
  def change
    create_table :pbls_knowledges, id: :uuid do |t|
      t.text :description
      t.uuid :project_id, index: true
      t.timestamps
    end
  end
end
