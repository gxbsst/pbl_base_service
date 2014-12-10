class  Curriculums::Phase < PgConnection
  belongs_to :subject, class_name: 'Curriculums::Subject'
  has_many :standards, dependent: :destroy
  validates :name, presence: true
end
