class Invitation < PgConnection
  validates :code, uniqueness: true, presence: true
end
