json.extract! user,
              :id,
              :username,
              :email,
              :first_name,
              :last_name,
              :age,
              :gender,
              :avatar,
              :type,
              :realname,
              :nickname,
              :disciplines,
              :interests,
              :school_id,
              :grade_id,
              :clazz_id,
              :title,
              :bio

if @include_school
  json.school do
    json.partial! 'v1/schools/school', school: user.school
  end
end
