class Clazz < PgConnection
  belongs_to :grade
  has_many :students, dependent: :destroy

end
