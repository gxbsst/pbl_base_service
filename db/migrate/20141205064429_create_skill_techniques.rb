class CreateSkillTechniques < ActiveRecord::Migration
  def change
    create_table :skills_techniques, id: :uuid do |t|
      t.string :title
      t.integer :position
      t.uuid :sub_category_id, index: true
      t.timestamps
    end
  end
end
