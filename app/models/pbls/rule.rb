class Pbls::Rule < PgConnection
  belongs_to :technique, class_name: 'Skills::Technique'
  belongs_to :project
  belongs_to :gauge
end
