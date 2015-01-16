class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools, id: :uuid do |t|
      t.uuid :region_id
      t.string :name
      t.uuid :user_id
      t.uuid :master_id

      t.timestamps
    end

    add_index :schools, :region_id

  end
end
