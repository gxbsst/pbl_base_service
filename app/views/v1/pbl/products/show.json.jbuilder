json.partial! 'product', product: @clazz_instance
json.product_form @clazz_instance.product_form_id if @include_product_form

if @include_resources
  json.resources do
    json.owner_type 'project_product'
    json.owner_id @clazz_instance.id
    json.resource_uri "/resources/project_product/#{@clazz_instance.id}"
  end
end
