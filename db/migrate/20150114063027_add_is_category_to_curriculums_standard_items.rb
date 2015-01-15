class AddIsCategoryToCurriculumsStandardItems < ActiveRecord::Migration
  def change
    add_column :curriculums_standard_items, :is_category, :boolean, default: false
  end
end
