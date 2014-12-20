json.partial! 'standard_item', standard_item: @clazz_instance

if @include_parents
  json.parents  do
    json.standard @clazz_instance.standard
    json.phase @clazz_instance.standard.phase
    json.subject @clazz_instance.standard.phase.subject
  end
end
