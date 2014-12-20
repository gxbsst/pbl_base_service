json.data do
  json.array! @collections do |technique|
    json.partial! 'technique', technique: technique
    if @include_parents
      json.parents  do
        json.sub_category technique.sub_category
        json.category technique.sub_category.category
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
