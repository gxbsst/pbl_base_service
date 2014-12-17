json.data do
  json.array! @collections do |collection|
    json.partial! 'resource', resource: collection
    if params[:include] == 'owner'
      json.owner [{owner_id: collection.owner_id, owner_type: collection.owner_type}]
    end
  end
end

json.meta do
  json.total_count @collections.count
  json.total_pages @collections.total_pages
  json.current_page @collections.current_page
  json.per_page @limit
end
