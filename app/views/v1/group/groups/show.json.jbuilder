json.partial! 'group', group: @clazz_instance

if @include_members
  json.members do
    json.array! @clazz_instance.member_ships do |member_ship|
      json.role member_ship.role
      json.partial! 'v1/users/user', user: member_ship.member
    end
  end
end
