class CreateCurriculumsStandardItems < ActiveRecord::Migration
  def change
    create_table :curriculums_standard_items, id: :uuid do |t|
      t.string :content
      t.integer :position
      t.uuid :standard_id, index: true
      t.timestamps
    end
  end
end
