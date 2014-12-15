json.data do
  json.array! @standards do |standard|

    json.id standard.id
    json.title standard.title
    json.position standard.position
    json.phase_id standard.phase_id

    if params[:include] && params[:include] == 'items'
      json.items do
        json.array! standard.items do |item|
          json.partial! 'item', item: item
        end
      end
    end
  end
end

json.meta do
  json.total_count @standards.count
  json.total_pages @standards.total_pages
  json.current_page @standards.current_page
  json.per_page @limit
end