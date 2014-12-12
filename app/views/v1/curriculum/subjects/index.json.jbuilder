json.data do
  json.array! @subjects
end

json.meta do
  json.total_count @subjects.count
  json.total_pages @subjects.total_pages
  json.current_page @subjects.current_page
  json.per_page @limit
end