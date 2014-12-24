json.data do
  json.array! @collections do |member_ship|
    json.role member_ship.role
    json.partial! 'v1/users/user', user: member_ship.member
  end
end

json.meta do
  json.total_count @collections.count
  json.total_pages @collections.total_pages
  json.current_page @collections.current_page
  json.per_page @limit
end
