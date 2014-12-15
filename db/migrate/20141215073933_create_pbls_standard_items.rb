class CreatePblsStandardItems < ActiveRecord::Migration
  def change
    create_table :pbls_standard_items, id: :uuid do |t|
      t.uuid :project_id, index: true
      t.uuid :standard_item_id, index: true
      t.timestamps
    end
  end
end
