module Skills
  class Technique < PgConnection
    self.table_name = 'skill_techniques'

    belongs_to :category, :class_name => 'Skills::Category'
    validates :title, presence: true
  end
end
