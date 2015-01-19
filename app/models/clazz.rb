class Clazz < PgConnection
  has_many :students, dependent: :destroy
  belongs_to :school
end
