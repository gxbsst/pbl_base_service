json.partial! 'product', product: @product
json.product_form @product.product_form_id if @include_product_form
