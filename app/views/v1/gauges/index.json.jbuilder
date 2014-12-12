json.data do
  json.array! @gauges
end

json.meta do
  json.total_count @gauges.count
  json.total_pages @gauges.total_pages
  json.current_page @gauges.current_page
  json.per_page @limit
end