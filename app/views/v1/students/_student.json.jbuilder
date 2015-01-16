json.extract! student, :id, :clazz_id, :user_id, :role
json.user do
  json.partial! 'v1/users/user', user: student.user
end
