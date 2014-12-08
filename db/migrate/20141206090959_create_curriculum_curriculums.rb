class CreateCurriculumCurriculums < ActiveRecord::Migration
  def change
    create_table :curriculum_curriculums, id: :uuid do |t|
      t.string :title
      t.integer :position
      t.uuid :phase_id, index: true
      t.timestamps
    end
  end
end
