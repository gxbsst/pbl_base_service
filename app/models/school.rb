class School < PgConnection
  has_many :clazzs, dependent: :destroy
end
