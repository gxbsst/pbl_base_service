class CreatePblProjects < ActiveRecord::Migration
  def change
    create_table :pbl_projects, id: :uuid do |t|
      t.string :name
      t.string :state
      t.text :description
      t.text :driven_issue
      t.text :standard_analysis
      t.integer :duration
      t.boolean :public
      t.string :limitation
      t.integer :location_id
      t.string :grade_id
      t.timestamps
    end
  end
end
