json.extract! @project, :id, :name, :driven_issue, :standard_analysis, :duration, :description, :limitation, :location_id, :grade_id, :standard_decompositions, :user_id, :rule_head, :rule_template, :tag_list, :duration_unit
json.techniques @project.techniques.try(:map, &:id) if @include_techniques
json.standard_items @project.standard_items.try(:map, &:id) if @include_standard_items
json.rules @project.rules.try(:map, &:id) if @include_rules
json.standard_decompositions @project.sandard_decompositions if @include_standard_decompositionss

