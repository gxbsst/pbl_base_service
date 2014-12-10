class Pbls::StandardDecomposition < PgConnection
  belongs_to :project
  validates :project, presence: true
end
