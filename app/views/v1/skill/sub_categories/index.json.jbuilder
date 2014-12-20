json.data do
  json.array! @collections do |sub_category|
    json.partial! 'sub_category', sub_category: sub_category

    if params[:include] && params[:include] == 'techniques'
      json.techniques do
        json.array! sub_category.techniques do |technique|
          json.partial! 'technique', technique: technique
        end
      end
    end
  end
end

json.meta do
  json.total_count @collections.count
  json.total_pages @collections.total_pages
  json.current_page @collections.current_page
  json.per_page @limit
end