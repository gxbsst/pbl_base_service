class CreateProductForms < ActiveRecord::Migration
  def change
    create_table :product_forms, id: :uuid do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
