class CreateSkillTechniques < ActiveRecord::Migration
  def change
    create_table :skill_techniques do |t|
      t.string :title
      t.integer :position
      t.uuid :category_id, index: true
      t.timestamps
    end
  end
end
