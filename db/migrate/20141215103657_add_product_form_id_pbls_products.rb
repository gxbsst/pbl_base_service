class AddProductFormIdPblsProducts < ActiveRecord::Migration
  def change
    add_column :pbls_products, :product_form_id, :uuid, index: true
  end
end
