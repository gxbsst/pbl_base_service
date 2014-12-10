class AddDescriptionToSkillsTechniques < ActiveRecord::Migration
  def change
    add_column :skills_techniques, :description, :text
  end
end
