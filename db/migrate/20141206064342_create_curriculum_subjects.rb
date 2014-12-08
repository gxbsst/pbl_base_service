class CreateCurriculumSubjects < ActiveRecord::Migration
  def change
    create_table :curriculum_subjects, id: :uuid do |t|
      t.string :name
      t.integer :position
      t.timestamps
    end
  end
end
