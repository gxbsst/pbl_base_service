class School < PgConnection
  has_many :grades, dependent: :destroy
end
