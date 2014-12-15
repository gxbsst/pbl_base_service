json.extract! @project, :id, :name, :driven_issue, :standard_analysis, :duration, :description, :limitation, :location_id, :grade_id, :standard_decompositions, :user_id, :rule_head, :rule_template
json.techniques @project.techniques if @include_techniques
json.standard_items @project.standard_items if @include_standard_items
json.rules @project.rules if @include_rules

