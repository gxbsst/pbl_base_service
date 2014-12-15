class CreatePblsRules < ActiveRecord::Migration
  def change
    create_table :pbls_rules, id: :uuid do |t|
      t.uuid :technique_id, index: true
      t.uuid :project_id, index: true
      t.uuid :gauge_id, index: true
      t.string :weight
      t.string :standard
      t.string :level_1
      t.string :level_2
      t.string :level_3
      t.string :level_4
      t.string :level_5
      t.string :level_6
      t.string :level_7

      t.timestamps
    end
  end
end
