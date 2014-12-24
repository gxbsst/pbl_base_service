class CreateGroupsMemberShips < ActiveRecord::Migration
  def change
    create_table :groups_member_ships, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :group_id
      t.text :role, array: true, default: []
      t.string :state

      t.timestamps
    end

    add_index :groups_member_ships, [:group_id, :user_id]
  end
end
