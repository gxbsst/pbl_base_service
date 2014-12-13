class CreatePblsKnowledges < ActiveRecord::Migration
  def change
    create_table :pbls_knowledges do |t|
      t.text :description

      t.timestamps
    end
  end
end
