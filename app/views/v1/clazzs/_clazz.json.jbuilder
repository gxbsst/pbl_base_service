json.extract! clazz, :id, :name, :school_id, :user_id, :master_id, :grade_id
json.students do
  json.array! clazz.students do |student|
    json.partial! 'v1/students/student', student: student
  end
end