class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources, id: :uuid do |t|
      t.string :name
      t.string :owner_id
      t.string :owner_type
      t.string :size
      t.string :ext
      t.string :mime_type
      t.string :md5
      t.string :key
      t.text :exif
      t.text :image_info
      t.string :image_ave
      t.string :persistent_id
      t.text :avinfo
      t.timestamps
    end

    add_index :resources, [:owner_id, :owner_type, :md5]
  end
end
