class CreateSkillsSubCategories < ActiveRecord::Migration
  def change
    create_table :skills_sub_categories, id: :uuid do |t|
      t.string :name
      t.uuid :category_id, index: true
      t.integer :position
      t.timestamps
    end
  end
end
