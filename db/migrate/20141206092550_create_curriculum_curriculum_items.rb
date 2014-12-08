class CreateCurriculumCurriculumItems < ActiveRecord::Migration
  def change
    create_table :curriculum_curriculum_items, id: :uuid do |t|
      t.string :content
      t.integer :position
      t.uuid :curriculum_id, index: true
      t.timestamps
    end
  end
end
