json.data do
  json.array! @collections do |product|
    json.partial! 'product', product: product

    if @include_product_form
      json.product_form  do
        json.product_form_id product.product_form_id
        json.product_form_uri "/product_forms/#{product.product_form_id}"
      end
    end

    if @include_resources
      json.resources do
        json.owner_type 'project_product'
        json.owner_id product.id
        json.resource_uri "/resources/project_product/#{product.id}"
      end
    end

  end
end

json.meta do
  json.total_count @collections.count
  json.total_pages @collections.total_pages
  json.current_page @collections.current_page
  json.per_page @limit
end
