class AddGroupsGroupNoSeqToGroupsGroups < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE SEQUENCE groups_groups_no_seq
       INCREMENT 1
       MINVALUE 1
       MAXVALUE 9223372036854775807
       START 1000
       CACHE 1;
    SQL
  end

  def down
    execute <<-SQL
      DROP SEQUENCE groups_groups_no_seq
    SQL
  end
end
