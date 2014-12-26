json.data do
  json.array! @collections do |follow|
    json.partial! 'follow', follow: follow
  end
end

json.meta do
  json.total_count @collections.count
  json.total_pages @collections.total_pages
  json.current_page @collections.current_page
  json.per_page @limit
end
