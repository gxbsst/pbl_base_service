class AddDescriptionToSkillTechniques < ActiveRecord::Migration
  def change
    add_column :skill_techniques, :description, :text
  end
end
