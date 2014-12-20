class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions, id: :uuid do |t|
      t.string :name
      t.string :type
      t.uuid :parent_id
      t.string :pinyin
      t.integer :position
      t.timestamps
    end
    add_index :regions,  [:parent_id, :pinyin]
  end
end
