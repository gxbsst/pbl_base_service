json.data do
  json.array! @phases
end

json.meta do
  json.total_count @phases.count
  json.total_pages @phases.total_pages
  json.current_page @phases.current_page
  json.per_page @limit
end