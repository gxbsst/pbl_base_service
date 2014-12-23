json.partial! 'v1/users/user', user: @clazz_instance
if @include_friends
  json.friends do
    json.array! @clazz_instance.friends do |user|
      json.partial! 'v1/users/user', user: user
    end
  end
end
