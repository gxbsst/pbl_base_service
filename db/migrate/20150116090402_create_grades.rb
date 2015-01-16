class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades, id: :uuid do |t|
      t.uuid :school_id
      t.string :name
      t.uuid :user_id
      t.uuid :master_id

      t.timestamps
    end

    add_index :grades, :school_id
  end
end
