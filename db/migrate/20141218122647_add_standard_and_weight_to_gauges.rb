class AddStandardAndWeightToGauges < ActiveRecord::Migration
  def change
    add_column :gauges, :standard, :string
    add_column :gauges, :weight, :string
  end
end
