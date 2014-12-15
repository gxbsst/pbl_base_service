class AddTitleToPblsProducts < ActiveRecord::Migration
  def change
    add_column :pbls_products, :title, :string
  end
end
