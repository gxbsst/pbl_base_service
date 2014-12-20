json.partial! 'project', project: @clazz_instance
if @include_techniques
  proc = lambda {|i| {id: i.id, technique_id: i.technique_id}}
  json.techniques @clazz_instance.techniques.try(:map, &proc)
end
if @include_standard_items
  proc = lambda {|i| {id: i.id, standard_item_id: i.standard_item_id}}
  json.standard_items @clazz_instance.standard_items.try(:map, &proc)
end

if @include_rules
  proc = lambda {|i| {id: i.id, gauge_id: i.gauge_id}}
  json.rules @clazz_instance.rules.try(:map, &proc)
end
json.standard_decompositions @clazz_instance.standard_decompositions if @include_standard_decompositions
json.knowledge @clazz_instance.knowledge if @include_knowledge
json.tasks @clazz_instance.tasks if @include_tasks

if @include_region
  json.region do
    json.region_id @clazz_instance.region_id
    json.region_uri "/regions/#{@clazz_instance.region_id}?include=parents"
  end
end
