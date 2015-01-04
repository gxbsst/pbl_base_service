class CreatePblsWorks < ActiveRecord::Migration
  def change
    create_table :pbls_works do |t|
      t.uuid :user_id
      t.uuid :assignee_id
      t.uuid :group_id
      t.string :state

      t.timestamps
    end
  end
end
