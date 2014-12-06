class CreateSkillCategories < ActiveRecord::Migration
  def change
    create_table :skill_categories, id: :uuid do |t|
      t.string :name
      t.uuid :skill_id, index: true
      t.integer :position
      t.timestamps
    end
  end
end
