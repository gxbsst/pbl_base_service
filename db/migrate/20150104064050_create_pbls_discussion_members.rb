class CreatePblsDiscussionMembers < ActiveRecord::Migration
  def change
    create_table :pbls_discussion_members, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :discussion_id
      t.text :role, array: true, default: []

      t.timestamps
    end
  end
end
