class CreateSkillsCategories < ActiveRecord::Migration
  def change
    create_table :skills_categories, id: :uuid do |t|
      t.string :name
      t.integer :position
      t.timestamps
    end
  end
end
