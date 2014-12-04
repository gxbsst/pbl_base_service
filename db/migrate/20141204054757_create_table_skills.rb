class CreateTableSkills < ActiveRecord::Migration
  def change
    create_table :skills, id: :uuid do |t|
      t.string :title
      t.timestamps
    end
  end
end
