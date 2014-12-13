json.data do
  json.array! @rules
end

json.meta do
  json.total_count @rules.count
  json.total_pages @rules.total_pages
  json.current_page @rules.current_page
  json.per_page @limit
end
