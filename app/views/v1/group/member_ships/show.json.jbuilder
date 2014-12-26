json.partial! 'member_ship', member_ship: @clazz_instance
json.user do
  json.partial! 'v1/users/user', user: @clazz_instance.member
end
