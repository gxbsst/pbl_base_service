class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students, id: :uuid do |t|
      t.uuid :clazz_id
      t.uuid :user_id
      t.text :role, array: true, default: []

      t.timestamps
    end

    add_index :students, :clazz_id
  end
end
