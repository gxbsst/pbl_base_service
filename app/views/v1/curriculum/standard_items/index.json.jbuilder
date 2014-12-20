json.data do
  json.array! @collections do |standard_item|
    json.partial! 'standard_item', standard_item: standard_item
    if @include_parents
      json.parents  do
        json.standard standard_item.standard
        json.phase standard_item.standard.phase
        json.subject standard_item.standard.phase.subject
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
