json.data do
  json.array! @sub_categories do |sub_category|
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
  json.total_count @sub_categories.count
  json.total_pages @sub_categories.total_pages
  json.current_page @sub_categories.current_page
  json.per_page @limit
end