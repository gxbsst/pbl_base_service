class AddReferenceCountToGauges < ActiveRecord::Migration
  def change
    add_column :gauges, :reference_count, :integer
  end
end
