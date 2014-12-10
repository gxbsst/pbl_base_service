class CreatePblsStandardDecompositions < ActiveRecord::Migration
  def change
    create_table :pbls_standard_decompositions, id: :uuid do |t|
      t.string :role
      t.string :verb
      t.string :technique
      t.string :noun
      t.string :product_name
      t.uuid :project_id, index: true
      t.timestamps
    end
  end
end
