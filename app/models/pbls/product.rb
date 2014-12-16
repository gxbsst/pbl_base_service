class Pbls::Product < PgConnection
  belongs_to :project
  belongs_to :product_form
  validates :project, presence: true
end
