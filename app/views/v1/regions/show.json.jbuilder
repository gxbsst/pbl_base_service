json.partial! 'region', region: @clazz_instance
if @include_children
  json.children do
    json.array! @clazz_instance.children do |region|
      json.partial! 'region', region: region
    end
  end
end

if @include_parents
  json.parents  do
    json.array! @clazz_instance.ancestors do |region|
      json.partial! 'region', region: region
    end
  end
end
