class CreateClazzs < ActiveRecord::Migration
  def change
    create_table :clazzs, id: :uuid do |t|
      t.uuid :grade_id
      t.string :name
      t.uuid :user_id
      t.uuid :master_id

      t.timestamps
    end

    add_index :clazzs, :grade_id
  end
end
