class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests, id: :uuid do |t|
      t.uuid :resource_id
      t.string :resource_type
      t.uuid :invitee_id
      t.uuid :user_id
      t.string :state
      t.string :relation

      t.timestamps
    end

    add_index :requests, :resource_id
    add_index :requests, :resource_type
    add_index :requests, :user_id
  end
end
