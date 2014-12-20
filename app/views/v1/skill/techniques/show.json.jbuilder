json.partial! 'technique', technique: @clazz_instance
if @include_parents
  json.parents  do
    json.sub_category @clazz_instance.sub_category
    json.category @clazz_instance.sub_category.category
  end
end
