json.extract! @project, :id, :name, :driven_issue, :standard_analysis, :duration, :description, :limitation, :location_id, :grade_id, :standard_decompositions, :user_id, :rule_head, :rule_template
json.techniques @project.techniques.try(:map, &:id) if @include_techniques
json.standard_items @project.standard_items.try(:map, &:id) if @include_standard_items
json.rules @project.rules.try(:map, &:id) if @include_rules
json.rules @project.sandard_decompositions.try(:map, &:id) if @include_decompositions

