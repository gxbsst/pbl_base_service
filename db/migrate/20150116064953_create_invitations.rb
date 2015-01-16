class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations, id: :uuid do |t|
      t.string :code
      t.string :owner_type
      t.uuid :owner_id

      t.timestamps
    end

    add_index :invitations, :code
    add_index :invitations, [:owner_type, :owner_id]
  end
end
