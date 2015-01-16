class Grade < PgConnection
  belongs_to :school
  has_many :clazzs, dependent: :destroy
end
