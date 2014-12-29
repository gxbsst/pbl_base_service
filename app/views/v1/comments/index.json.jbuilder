json.data do
  json.array! @collections do |collection|
    json.partial! 'comment', comment: collection
    if params[:include] == 'commentable'
      json.commentable [{commentable_id: collection.commentable_id, commentable_type: collection.commentable_type}]
    end
  end
end

json.meta do
  json.total_count @collections.count
  json.total_pages @collections.total_pages
  json.current_page @collections.current_page
  json.per_page @limit
end
