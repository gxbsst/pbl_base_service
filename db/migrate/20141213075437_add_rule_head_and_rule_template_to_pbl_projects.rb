class AddRuleHeadAndRuleTemplateToPblProjects < ActiveRecord::Migration
  def change
    add_column :pbls_projects, :rule_head, :string
    add_column :pbls_projects, :rule_template, :string
  end
end
