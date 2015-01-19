class CreatePblsSearchers < ActiveRecord::Migration
  def change
    create_table :pbls_searchers, id: :uuid do |t|
      t.string :subject
      t.string :phase
      t.string :technique
      t.string :name
      t.uuid :project_id

      t.timestamps
    end
    add_index :pbls_searchers, :subject
    add_index :pbls_searchers, :phase
    add_index :pbls_searchers, :technique
    add_index :pbls_searchers, :name
    add_index :pbls_searchers, :project_id
  end
end
