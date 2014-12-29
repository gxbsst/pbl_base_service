json.data do
  json.array! @collections do |member_ship|
    json.partial! 'member_ship', member_ship: member_ship
    if params[:user_id].present?
      json.group do
        json.partial! 'v1/group/groups/group', group: member_ship.group
      end
    end
    json.user do
      json.partial! 'v1/users/user', user: member_ship.member
    end
  end
end

json.meta do
  json.total_count @collections.count
  json.total_pages @collections.total_pages
  json.current_page @collections.current_page
  json.per_page @limit
end
