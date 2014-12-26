json.partial! 'group', group: @clazz_instance

if @include_member_ships
  json.member_ships do
    json.array! @clazz_instance.member_ships do |member_ship|
      json.partial! 'v1/group/member_ships/member_ship', member_ship: member_ship
      json.member do
        json.partial! 'v1/users/user', user: member_ship.member
      end

    end
  end
end
