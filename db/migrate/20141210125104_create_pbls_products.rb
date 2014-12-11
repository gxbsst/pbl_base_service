class CreatePblsProducts < ActiveRecord::Migration
  def change
    create_table :pbls_products, id: :uuid do |t|
      t.string :form
      t.text :description
      t.boolean :is_final
      t.uuid :project_id, index: true
      t.timestamps
    end
  end
end
