class Student < PgConnection
  belongs_to :user
  belongs_to :clazz
end
