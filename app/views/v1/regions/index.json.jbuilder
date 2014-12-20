json.data do
  json.array! @collections do  |region|
    json.partial! 'region', region: region
  end
end

json.meta do
  json.total_count @collections.count
  json.total_pages @collections.total_pages
  json.current_page @collections.current_page
  json.per_page @limit
end
