json.data do
  json.array! @products
end

json.meta do
  json.total_count @products.count
  json.total_pages @products.total_pages
  json.current_page @products.current_page
  json.per_page @limit
end
