class Student < PgConnection
  belongs_to :user
  belongs_to :clazz

  validates :user_id, uniqueness: { scope: :clazz_id }
end
