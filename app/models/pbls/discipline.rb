class Pbls::Discipline < PgConnection
  validates :name, presence: true
end
