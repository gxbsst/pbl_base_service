class Gauge < PgConnection
  belongs_to :technique, class_name: 'Skills::Technique'
  validates :technique, presence: true
end
