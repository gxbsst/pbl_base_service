class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.integer :gender
      t.timestamps
    end
  end
end

