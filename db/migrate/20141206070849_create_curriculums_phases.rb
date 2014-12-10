class CreateCurriculumsPhases < ActiveRecord::Migration
  def change
    create_table :curriculums_phases, id: :uuid do |t|
      t.string :name
      t.integer :position
      t.uuid :subject_id, index: true
      t.timestamps
    end
  end
end
