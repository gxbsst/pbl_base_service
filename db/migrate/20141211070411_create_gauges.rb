class CreateGauges < ActiveRecord::Migration
  def change
    create_table :gauges, id: :uuid do |t|
      t.string :level_1
      t.string :level_2
      t.string :level_3
      t.string :level_4
      t.string :level_5
      t.string :level_6
      t.string :level_7
      t.uuid :technique_id, index: true
      t.timestamps
    end
  end
end
