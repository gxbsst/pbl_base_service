class CreateRegionHierarchies < ActiveRecord::Migration
  def change
    create_table :region_hierarchies, id: false do |t|
      t.uuid :ancestor_id, null: false
      t.uuid :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :region_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "anc_desc_idx"

    add_index :region_hierarchies, [:descendant_id],
      name: "desc_idx"
  end
end
