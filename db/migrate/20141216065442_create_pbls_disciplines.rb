class CreatePblsDisciplines < ActiveRecord::Migration
  def change
    create_table :pbls_disciplines, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
