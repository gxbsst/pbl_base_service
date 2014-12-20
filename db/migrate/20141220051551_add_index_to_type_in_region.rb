class AddIndexToTypeInRegion < ActiveRecord::Migration
  def change
    add_index :regions, :type
  end
end
