class Pbls::Product < PgConnection
  belongs_to :project
  validates :project, presence: true
end
