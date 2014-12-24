class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups_groups, id: :uuid do |t|
      t.string :name
      t.text :description
      t.uuid :user_id
      t.timestamps
    end
    add_index :groups_groups, :user_id
  end
end
