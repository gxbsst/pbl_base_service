json.partial! 'project', project: @project
if @include_techniques
  proc = lambda {|i| {id: i.id, technique_id: i.technique_id}}
  json.techniques @project.techniques.try(:map, &proc)
end
if @include_standard_items
  proc = lambda {|i| {id: i.id, standard_item_id: i.standard_item_id}}
  json.standard_items @project.standard_items.try(:map, &proc)
end

if @include_rules
  proc = lambda {|i| {id: i.id, gauge_id: i.gauge_id}}
  json.rules @project.rules.try(:map, &proc)
end
json.standard_decompositions @project.standard_decompositions if @include_standard_decompositions
json.knowledge @project.knowledge if @include_knowledge
json.tasks @project.tasks if @include_tasks
