class CreateCurriculumsSubjects < ActiveRecord::Migration
  def change
    create_table :curriculums_subjects, id: :uuid do |t|
      t.string :name
      t.integer :position
      t.timestamps
    end
  end
end
