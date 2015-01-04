class CreatePblsDiscussions < ActiveRecord::Migration
  def change
    create_table :pbls_discussions, id: :uuid do |t|
      t.string :name
      t.integer :uid
      t.uuid :project_id

      t.timestamps
    end
  end
end
