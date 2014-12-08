class CreateCurriculumPhases < ActiveRecord::Migration
  def change
    create_table :curriculum_phases, id: :uuid do |t|
      t.string :name
      t.integer :position
      t.uuid :subject_id, index: true
      t.timestamps
    end
  end
end
