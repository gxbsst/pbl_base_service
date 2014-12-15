json.extract! @product, :id, :form, :description, :project_id, :product_form_id
json.product_form @product.product_form_id if @include_product_form
